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
  const formattedDate = date.toLocaleDateString('es-ES', {
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
      : '<li>Sin logros nuevos hoy</li>';
    
    childrenHtml += `
      <div style="background: ${index % 2 === 0 ? '#f8f9fa' : '#ffffff'}; padding: 20px; margin: 10px 0; border-radius: 10px; border-left: 4px solid #4CAF50;">
        <h3 style="margin: 0 0 10px 0; color: #333;">${child.name} ${levelEmoji}</h3>
        <div style="margin: 15px 0;">
          <p style="margin: 5px 0; color: #666;">
            <strong>📚 Palabras aprendidas hoy:</strong> ${child.wordsLearned}
          </p>
          <p style="margin: 5px 0; color: #666;">
            <strong>⭐ Niveles completados:</strong> ${child.levelsCompleted}
          </p>
          <p style="margin: 5px 0; color: #666;">
            <strong>🎯 Puntuación total:</strong> ${child.score}
          </p>
        </div>
        <div style="margin-top: 15px;">
          <h4 style="margin: 0 0 10px 0; color: #666;">Logros de hoy:</h4>
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
    subject: `🎉 Progreso de hoy de ${childrenStats.map(c => c.name).join(' y ')} - ${formattedDate}`,
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reporte de Progreso - Boby App</title>
      </head>
      <body style="font-family: 'Comic Sans MS', 'Chalkboard SE', sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4;">
        <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <!-- Header -->
          <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center;">
            <h1 style="margin: 0; color: #ffffff; font-size: 28px;">🌟 ¡Gran trabajo hoy! 🌟</h1>
            <p style="margin: 10px 0 0 0; color: #ffffff; font-size: 16px;">${formattedDate}</p>
          </div>
          
          <!-- Content -->
          <div style="padding: 30px;">
            <p style="margin: 0 0 20px 0; color: #666; font-size: 16px; line-height: 1.6;">
              Hola ${parentName}, aquí está el resumen del progreso de hoy:
            </p>
            
            ${childrenHtml}
            
            <!-- Footer -->
            <div style="margin-top: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 10px; text-align: center;">
              <p style="margin: 0 0 10px 0; color: #666; font-size: 14px;">
                ¡Sigue así! El aprendizaje es un viaje increíble 🚀
              </p>
              <p style="margin: 0; color: #999; font-size: 12px;">
                <em>Este reporte fue generado automáticamente por Boby App</em>
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