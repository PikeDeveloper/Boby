const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();
const db = admin.firestore();

// Configura SendGrid (necesitas establecer la API key en Firebase Console)
// Configuración: Runtime config variables > sendgrid_api_key
const SENDGRID_API_KEY = (functions.config().sendgrid && functions.config().sendgrid.api_key) || process.env.SENDGRID_API_KEY;
const SENDER_EMAIL = (functions.config().sendgrid && functions.config().sendgrid.from_email) || process.env.SENDER_EMAIL || 'cabelloenrique.rcl@gmail.com';
sgMail.setApiKey(SENDGRID_API_KEY);

// Función programada que se ejecuta diariamente a las 8 PM
exports.sendDailyStatsEmail = functions.pubsub.schedule('0 20 * * *')
  .timeZone('America/Mexico_City')
  .onRun(async (context) => {
    console.log('Iniciando envío de estadísticas diarias...');
    
    try {
      // Obtener todos los padres que tienen email habilitado
      const parentsSnapshot = await db.collection('parents')
        .where('emailEnabled', '==', true)
        .get();
      
      if (parentsSnapshot.empty) {
        console.log('No hay padres con email habilitado');
        return null;
      }
      
      const today = new Date();
      const dateKey = `${today.getFullYear()}-${today.getMonth() + 1}-${today.getDate()}`;
      
      for (const parentDoc of parentsSnapshot.docs) {
        const parentData = parentDoc.data();
        const childrenIds = parentData.childrenIds || [];
        
        if (childrenIds.length === 0) {
          console.log(`Padre ${parentData.email} no tiene hijos asociados`);
          continue;
        }
        
        // Obtener estadísticas de cada hijo
        const childrenStats = [];
        
        for (const childId of childrenIds) {
          const statsDoc = await db.collection('stats')
            .doc(childId)
            .collection('daily_stats')
            .doc(dateKey)
            .get();
          
          if (statsDoc.exists) {
            const stats = statsDoc.data();
            childrenStats.push({
              name: stats.childName,
              wordsLearned: stats.wordsLearned || 0,
              levelsCompleted: stats.levelsCompleted || 0,
              currentLevel: stats.currentLevel || 'Bronze',
              score: stats.score || 0,
              achievements: stats.achievements || [],
            });
          }
        }
        
        if (childrenStats.length > 0) {
          // Enviar email con las estadísticas
          await sendStatsEmail(parentData.email, parentData.name, childrenStats, today);
        }
      }
      
      console.log('Envío de estadísticas completado exitosamente');
      return null;
    } catch (error) {
      console.error('Error en envío de estadísticas:', error);
      throw new Error('Error en envío de estadísticas');
    }
  });

// Función para enviar email individual de estadísticas
async function sendStatsEmail(parentEmail, parentName, childrenStats, date) {
  const formattedDate = date.toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
  
  // Generar HTML del email con las estadísticas
  let childrenHtml = '';
  
  childrenStats.forEach((child, index) => {
    const levelEmoji = getLevelEmoji(child.currentLevel);
    const achievementsList = child.achievements.length > 0 
      ? child.achievements.map(a => `<li>🏆 ${a}</li>`).join('')
      : '<li>Just regular awesome learning today!</li>';
    
    childrenHtml += `
      <div style="background: ${index % 2 === 0 ? '#f8f9fa' : '#ffffff'}; padding: 20px; margin: 10px 0; border-radius: 10px; border-left: 4px solid #4CAF50;">
        <h3 style="margin: 0 0 10px 0; color: #333;">${child.name} ${levelEmoji}</h3>
        <div style="margin: 15px 0;">
          <p style="margin: 5px 0; color: #666;">
            <strong>📚 New words mastered:</strong> ${child.wordsLearned}
          </p>
          <p style="margin: 5px 0; color: #666;">
            <strong>⭐ Levels conquered:</strong> ${child.levelsCompleted}
          </p>
          <p style="margin: 5px 0; color: #666;">
            <strong>🎯 Total score:</strong> ${child.score}
          </p>
        </div>
        <div style="margin-top: 15px;">
          <h4 style="margin: 0 0 10px 0; color: #666;">Today's highlights:</h4>
          <ul style="margin: 0; padding-left: 20px; color: #666;">
            ${achievementsList}
          </ul>
        </div>
      </div>
    `;
  });
  
  const emailContent = {
    to: parentEmail,
    from: { email: SENDER_EMAIL, name: 'Boby App' },
    subject: `🎉 Today's Progress for ${childrenStats.map(c => c.name).join(' & ')} - ${formattedDate}`,
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Progress Report - Boby App</title>
      </head>
      <body style="font-family: 'Comic Sans MS', 'Chalkboard SE', sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
        <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <!-- Header -->
          <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center;">
            <h1 style="margin: 0; color: #ffffff; font-size: 28px;">🌟 Amazing work today! 🌟</h1>
            <p style="margin: 10px 0 0 0; color: #ffffff; font-size: 16px;">${formattedDate}</p>
          </div>
          
          <!-- Content -->
          <div style="padding: 30px;">
            <p style="margin: 0 0 20px 0; color: #666; font-size: 16px; line-height: 1.6;">
              Hi ${parentName}, here's a quick look at the fantastic progress made today:
            </p>
            
            ${childrenHtml}
            
            <!-- Footer -->
            <div style="margin-top: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 10px; text-align: center;">
              <p style="margin: 0 0 10px 0; color: #666; font-size: 14px;">
                Keep it up! Learning is an incredible adventure 🚀
              </p>
              <p style="margin: 0; color: #999; font-size: 12px;">
                <em>This report was automatically generated by Boby App</em>
              </p>
            </div>
          </div>
        </div>
      </body>
      </html>
    `
  };
  
  try {
    await sgMail.send(emailContent);
    console.log(`Email enviado exitosamente a ${parentEmail}`);
  } catch (error) {
    console.error(`Error enviando email a ${parentEmail}:`, error);
    throw error;
  }
}

// Función auxiliar para obtener emoji según nivel
function getLevelEmoji(level) {
  const levelEmojis = {
    'Bronze': '🥉',
    'Silver': '🥈', 
    'Gold': '🥇',
    'Diamond': '💎',
    'Platinum': '🌟'
  };
  return levelEmojis[level] || '🎯';
}

// Función para actualizar estadísticas en tiempo real (trigger)
exports.onStatsUpdate = functions.firestore
  .document('stats/{childId}/daily_stats/{date}')
  .onWrite(async (change, context) => {
    const stats = change.after.data();
    
    if (!stats) return null;
    
    // Verificar si hay logros nuevos para enviar notificación inmediata
    const achievements = stats.achievements || [];
    const previousAchievements = change.before.exists 
      ? (change.before.data().achievements || []) 
      : [];
    
    const newAchievements = achievements.filter(a => !previousAchievements.includes(a));
    
    if (newAchievements.length > 0) {
      // Aquí podrías enviar una notificación push inmediata
      console.log(`Nuevos logros detectados: ${newAchievements.join(', ')}`);
    }
    
    return null;
  });

// Función para procesar correos pendientes (trigger)
exports.onPendingEmailCreated = functions.firestore
  .document('pending_emails/{emailId}')
  .onCreate(async (snapshot, context) => {
    const emailData = snapshot.data();
    
    if (emailData.status !== 'pending') return null;
    
    try {
      if (emailData.type === 'welcome') {
        await sendWelcomeEmailProcess(emailData.to, emailData.childName);
      } else if (emailData.type === 'achievement') {
        await sendAchievementEmailProcess(emailData.to, emailData.childName, emailData.achievementDescription);
      }
      
      // Marcar como procesado
      await snapshot.ref.update({ status: 'sent' });
      
      return null;
    } catch (error) {
      console.error('Error processing pending email:', error);
      await snapshot.ref.update({ status: 'failed', error: error.message });
      throw error;
    }
  });

// Función para enviar correo de bienvenida
async function sendWelcomeEmailProcess(parentEmail, childName) {
  const formattedDate = new Date().toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
  
  const emailContent = {
    to: parentEmail,
    from: { email: SENDER_EMAIL, name: 'Boby App' },
    subject: `🎉 Congratulations! ${childName} has joined the world of Boby!`,
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Welcome to Boby App</title>
      </head>
      <body style="font-family: 'Comic Sans MS', 'Chalkboard SE', sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
        <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <!-- Header -->
          <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 30px; text-align: center;">
            <h1 style="margin: 0; color: #ffffff; font-size: 32px;">🎉 Congratulations!</h1>
            <p style="margin: 15px 0 0 0; color: #ffffff; font-size: 18px;">${childName} has now joined the world of Boby!</p>
          </div>
          
          <!-- Content -->
          <div style="padding: 40px 30px;">
            <p style="margin: 0 0 20px 0; color: #666; font-size: 18px; line-height: 1.6;">
              Hello! We're excited to let you know that <strong>${childName}</strong> has started using Boby App, a very engaging app designed to practice English.
            </p>
            
            <div style="background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); padding: 25px; border-radius: 15px; margin: 25px 0;">
              <h3 style="margin: 0 0 15px 0; color: #333; font-size: 20px;">📬 What to expect:</h3>
              <ul style="margin: 0; padding-left: 20px; color: #666; font-size: 16px; line-height: 1.8;">
                <li>We will be sending you reports of ${childName}'s progress</li>
                <li>Updates on achievements and milestones reached</li>
                <li>Insights into vocabulary and skills development</li>
                <li>Fun and engaging learning activities</li>
              </ul>
            </div>
            
            <p style="margin: 25px 0 20px 0; color: #666; font-size: 18px; line-height: 1.6;">
              You'll be receiving all the progress and achievements that ${childName} obtains while using the app. This way, you can stay connected and celebrate every step of their English learning journey!
            </p>
            
            <div style="text-align: center; margin: 30px 0;">
              <div style="display: inline-block; padding: 15px 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50px; color: white; font-size: 18px; font-weight: bold;">
                🚀 Let's learn together!
              </div>
            </div>
            
            <!-- Footer -->
            <div style="margin-top: 40px; padding: 25px; background-color: #f8f9fa; border-radius: 15px; text-align: center;">
              <p style="margin: 0 0 10px 0; color: #666; font-size: 16px;">
                We're excited to be part of ${childName}'s learning journey! 🌟
              </p>
              <p style="margin: 0; color: #999; font-size: 14px;">
                <em>This email was automatically generated by Boby App</em>
              </p>
              <p style="margin: 10px 0 0 0; color: #999; font-size: 12px;">
                ${formattedDate}
              </p>
            </div>
          </div>
        </div>
      </body>
      </html>
    `
  };
  
  try {
    await sgMail.send(emailContent);
    console.log(`Welcome email sent successfully to ${parentEmail}`);
  } catch (error) {
    console.error(`Error sending welcome email to ${parentEmail}:`, error);
    if (error.response) {
      console.error('SendGrid Error Body:', JSON.stringify(error.response.body));
    }
    throw error;
  }
}

// Función para enviar correo de logro
async function sendAchievementEmailProcess(parentEmail, childName, achievementDescription) {
  const formattedDate = new Date().toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
  
  const emailContent = {
    to: parentEmail,
    from: { email: SENDER_EMAIL, name: 'Boby App' },
    subject: `🎉 Great news! ${childName} just reached a new milestone in Boby`,
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Brilliant Milestone in Boby App!</title>
      </head>
      <body style="font-family: 'Comic Sans MS', 'Chalkboard SE', sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
        <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <!-- Header -->
          <div style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); padding: 40px 30px; text-align: center;">
            <h1 style="margin: 0; color: #ffffff; font-size: 32px;">🏆 Brilliant Milestone!</h1>
            <p style="margin: 15px 0 0 0; color: #ffffff; font-size: 18px;">${childName} is doing amazing!</p>
          </div>
          
          <!-- Content -->
          <div style="padding: 40px 30px;">
            <p style="margin: 0 0 20px 0; color: #666; font-size: 18px; line-height: 1.6;">
              Hello there! We couldn't wait to share some incredible news about <strong>${childName}'s</strong> learning journey.
            </p>
            
            <div style="background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%); padding: 25px; border-radius: 15px; margin: 25px 0; border-left: 5px solid #ff9a9e;">
              <h3 style="margin: 0 0 15px 0; color: #333; font-size: 20px;">⭐ New Achievement Unlocked:</h3>
              <p style="margin: 0; color: #666; font-size: 18px; line-height: 1.6;">
                <strong>${achievementDescription}</strong>
              </p>
            </div>
            
            <p style="margin: 25px 0 20px 0; color: #666; font-size: 18px; line-height: 1.6;">
              Give ${childName} a huge high-five from us! These little steps build huge confidence in speaking and understanding English.
            </p>
            
            <div style="text-align: center; margin: 30px 0;">
              <div style="display: inline-block; padding: 15px 30px; background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); border-radius: 50px; color: white; font-size: 18px; font-weight: bold;">
                🎉 Way to go!
              </div>
            </div>
            
            <!-- Footer -->
            <div style="margin-top: 40px; padding: 25px; background-color: #f8f9fa; border-radius: 15px; text-align: center;">
              <p style="margin: 0 0 10px 0; color: #666; font-size: 16px;">
                Let's keep learning and having fun! 🌟
              </p>
              <p style="margin: 0; color: #999; font-size: 14px;">
                <em>This email was automatically generated by Boby App</em>
              </p>
              <p style="margin: 10px 0 0 0; color: #999; font-size: 12px;">
                ${formattedDate}
              </p>
            </div>
          </div>
        </div>
      </body>
      </html>
    `
  };
  
  try {
    await sgMail.send(emailContent);
    console.log(`Achievement email sent successfully to ${parentEmail}`);
  } catch (error) {
    console.error(`Error sending achievement email to ${parentEmail}:`, error);
    if (error.response) {
      console.error('SendGrid Error Body:', JSON.stringify(error.response.body));
    }
    throw error;
  }
}

// Trigger for daily report creation
exports.onDailyReportCreated = functions.firestore
  .document('daily_reports/{reportId}')
  .onCreate(async (snapshot, context) => {
    const reportData = snapshot.data();
    
    if (reportData.status !== 'pending') return null;
    
    try {
      await sendDailyReportEmail(
        reportData.parentEmail,
        reportData.childName,
        reportData.stats,
        reportData.newMilestones || [],
        reportData.streak || 1,
        reportData.date
      );
      
      // Mark as sent
      await snapshot.ref.update({ status: 'sent' });
      console.log(`Daily report processed and sent successfully for ${reportData.parentEmail}`);
      return null;
    } catch (error) {
      console.error('Error processing daily report email:', error);
      await snapshot.ref.update({ status: 'failed', error: error.message });
      throw error;
    }
  });

async function sendDailyReportEmail(parentEmail, childName, stats, newMilestones, streak, date) {
  const formattedDate = new Date().toLocaleDateString('es-ES', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  // Construct Milestones Section
  let milestonesHtml = '';
  if (newMilestones && newMilestones.length > 0) {
    const items = newMilestones.map(m => `<li style="margin-bottom: 8px;">${m}</li>`).join('');
    milestonesHtml = `
      <div style="background-color: #E8F5E9; border-left: 5px solid #4CAF50; border-radius: 12px; padding: 20px; margin-bottom: 25px;">
        <h3 style="margin: 0 0 12px 0; color: #2E7D32; font-size: 18px; font-weight: bold;">🎉 ¡Nuevos Logros de Hoy!</h3>
        <ul style="margin: 0; padding-left: 20px; color: #1B5E20; font-size: 15px; line-height: 1.6;">
          ${items}
        </ul>
      </div>
    `;
  }

  // Construct Streak Section
  let streakHtml = '';
  if (streak > 1) {
    streakHtml = `
      <div style="background-color: #FFF9C4; border-radius: 12px; padding: 15px; text-align: center; margin-bottom: 25px; border: 1px dashed #FBC02D;">
        <span style="font-size: 16px; font-weight: bold; color: #F57F17;">🔥 ¡Racha Activa: ${streak} días seguidos practicando! 🔥</span>
      </div>
    `;
  }

  // Construct Stats Section
  const gameDisplayNames = {
    'DragAndDrop': 'Drag & Drop 🎵',
    'ScrambleWord': 'Scramble Word 🔤',
    'Tales': 'Tales 📖',
    'Math': 'Math ➕',
    'Memory': 'Memory 🧠',
    'MatchIt': 'Match It 🎯',
    'WordGuess': 'Word Guess 💬'
  };

  let statsHtml = '';
  let activeGamesCount = 0;

  for (const gameKey in stats) {
    if (Object.prototype.hasOwnProperty.call(stats, gameKey)) {
      const game = stats[gameKey];
      if (game.total > 0) {
        activeGamesCount++;
        const accuracyPct = Math.round(game.accuracy * 100);
        let levelBadge = '🥉 Bronce';
        let badgeColor = '#8D6E63';
        if (accuracyPct >= 90) {
          levelBadge = '💎 Diamante';
          badgeColor = '#00B0FF';
        } else if (accuracyPct >= 80) {
          levelBadge = '🥇 Oro';
          badgeColor = '#FFD700';
        } else if (accuracyPct >= 50) {
          levelBadge = '🥈 Plata';
          badgeColor = '#B0BEC5';
        }

        statsHtml += `
          <div style="background-color: #ffffff; border: 1px solid #E0E0E0; border-radius: 12px; padding: 15px; margin-bottom: 15px;">
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
              <tr>
                <td style="font-size: 16px; font-weight: bold; color: #333; padding-bottom: 8px;">
                  ${gameDisplayNames[gameKey] || gameKey}
                </td>
                <td align="right" style="padding-bottom: 8px;">
                  <span style="background-color: ${badgeColor}20; color: ${badgeColor}; padding: 3px 8px; border-radius: 20px; font-size: 12px; font-weight: bold;">
                    ${levelBadge}
                  </span>
                </td>
              </tr>
              <tr>
                <td colspan="2" style="border-top: 1px solid #F5F5F5; padding-top: 10px;">
                  <table cellpadding="0" cellspacing="0" border="0" width="100%" style="text-align: center;">
                    <tr>
                      <td width="33%">
                        <div style="font-size: 12px; color: #9E9E9E; text-transform: uppercase; margin-bottom: 4px;">Correctas</div>
                        <div style="font-size: 18px; font-weight: bold; color: #4CAF50;">${game.correct}</div>
                      </td>
                      <td width="33%">
                        <div style="font-size: 12px; color: #9E9E9E; text-transform: uppercase; margin-bottom: 4px;">Incorrectas</div>
                        <div style="font-size: 18px; font-weight: bold; color: #F44336;">${game.wrong}</div>
                      </td>
                      <td width="34%">
                        <div style="font-size: 12px; color: #9E9E9E; text-transform: uppercase; margin-bottom: 4px;">Precisión</div>
                        <div style="font-size: 18px; font-weight: bold; color: #2196F3;">${accuracyPct}%</div>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>
        `;
      }
    }
  }

  if (activeGamesCount === 0) {
    statsHtml = `
      <div style="text-align: center; color: #9E9E9E; padding: 20px; background-color: #fafafa; border-radius: 12px; border: 1px dashed #E0E0E0;">
        No hubo intentos de juego hoy. ¡Anímale a jugar mañana! 🎮
      </div>
    `;
  }

  const emailContent = {
    to: parentEmail,
    from: { email: SENDER_EMAIL, name: 'Boby App' },
    subject: `📊 Reporte diario de progreso de ${childName} - Boby App`,
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reporte de Progreso Diario - Boby App</title>
      </head>
      <body style="font-family: 'Comic Sans MS', 'Chalkboard SE', sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
        <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <!-- Header -->
          <div style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); padding: 35px 30px; text-align: center;">
            <h1 style="margin: 0; color: #ffffff; font-size: 28px;">🌟 Reporte de Progreso 🌟</h1>
            <p style="margin: 10px 0 0 0; color: #ffffff; font-size: 16px;">¡Mira lo que ha logrado ${childName} hoy!</p>
          </div>
          
          <!-- Content -->
          <div style="padding: 30px;">
            <p style="margin: 0 0 20px 0; color: #666; font-size: 16px; line-height: 1.6;">
              Hola, aquí te compartimos los logros y estadísticas de aprendizaje de <strong>${childName}</strong> correspondientes al día de hoy (${date}):
            </p>
            
            ${milestonesHtml}
            
            ${streakHtml}
            
            <h3 style="color: #333; border-bottom: 2px solid #EEEEEE; padding-bottom: 8px; margin-bottom: 15px; font-size: 18px;">📊 Resumen por Juego</h3>
            
            ${statsHtml}
            
            <!-- Footer -->
            <div style="margin-top: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 10px; text-align: center;">
              <p style="margin: 0 0 10px 0; color: #666; font-size: 14px; font-weight: bold;">
                ¡El aprendizaje es un viaje increíble! Sigue motivando a ${childName} 🚀
              </p>
              <p style="margin: 0; color: #999; font-size: 12px;">
                <em>Este reporte fue generado automáticamente por Boby App</em>
              </p>
              <p style="margin: 10px 0 0 0; color: #999; font-size: 11px;">
                ${formattedDate}
              </p>
            </div>
          </div>
        </div>
      </body>
      </html>
    `
  };

  try {
    await sgMail.send(emailContent);
    console.log(`Daily report email sent successfully to ${parentEmail}`);
  } catch (error) {
    console.error(`Error sending daily report email to ${parentEmail}:`, error);
    if (error.response) {
      console.error('SendGrid Error Body:', JSON.stringify(error.response.body));
    }
    throw error;
  }
}