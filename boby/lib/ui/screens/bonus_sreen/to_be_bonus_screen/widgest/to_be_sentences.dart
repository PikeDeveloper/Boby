class ToBeSentences {
  static List sentences = [
    {
      "verb": "is",
      "sentence": "The cat is an animal",
      "wrong": ["are", "am", "was", "be"],
    },
    {
      "verb": "am",
      "sentence": "I am very happy today",
      "wrong": ["is", "are", "were", "be"],
    },
    {
      "verb": "are",
      "sentence": "They are at the park",
      "wrong": ["is", "am", "was", "be"],
    },
    {
      "verb": "is not",
      "sentence": "The dog is not hungry",
      "wrong": ["are", "am not", "was", "is"],
    },
    {
      "verb": "isn't",
      "sentence": "She isn't ready yet",
      "wrong": ["aren't", "am not", "wasn't", "is"],
    },
    {
      "verb": "aren't",
      "sentence": "You aren't late",
      "wrong": ["isn't", "am not", "were", "are"],
    },
    {
      "verb": "I'm",
      "sentence": "I'm a good student",
      "wrong": ["is", "are", "was", "be"],
    },
    {
      "verb": "he's",
      "sentence": "He's a smart boy",
      "wrong": ["isn't", "were", "am", "be"],
    },
    {
      "verb": "they're",
      "sentence": "They're very friendly",
      "wrong": ["is", "am", "was", "be"],
    },
    {
      "verb": "was",
      "sentence": "She was tired yesterday",
      "wrong": ["were", "is", "am", "be"],
    },
    {
      "verb": "were",
      "sentence": "We were at home last night",
      "wrong": ["was", "are", "is", "am"],
    },
    {
      "verb": "wasn't",
      "sentence": "He wasn't in class",
      "wrong": ["weren't", "isn't", "aren't", "was"],
    },
    {
      "verb": "weren't",
      "sentence": "They weren't ready",
      "wrong": ["wasn't", "isn't", "am not", "were"],
    },
    {
      "verb": "will be",
      "sentence": "I will be there tomorrow",
      "wrong": ["was", "am", "is", "be"],
    },
    {
      "verb": "will be",
      "sentence": "The exam will be difficult",
      "wrong": ["is", "was", "are", "will being"],
    },
    {
      "verb": "won't be",
      "sentence": "She won't be happy about it",
      "wrong": ["isn't", "wasn't", "aren't", "will be"],
    },
    {
      "verb": "am being",
      "sentence": "I am being very patient",
      "wrong": ["is being", "are being", "was", "am"],
    },
    {
      "verb": "is being",
      "sentence": "The baby is being very quiet",
      "wrong": ["are being", "was being", "is", "be"],
    },
    {
      "verb": "are being",
      "sentence": "You are being rude",
      "wrong": ["is being", "am being", "were", "are"],
    },
    {
      "verb": "was being",
      "sentence": "He was being silly yesterday",
      "wrong": ["is being", "are being", "was", "were being"],
    },
    {
      "verb": "were being",
      "sentence": "They were being loud in class",
      "wrong": ["was being", "are being", "were", "be"],
    },
    {
      "verb": "will be being",
      "sentence": "You will be being observed during the test",
      "wrong": ["will be", "were being", "is being", "are"],
    },
    {
      "verb": "is",
      "sentence": "The sky is blue today",
      "wrong": ["are", "was", "be", "am"],
    },
    {
      "verb": "are",
      "sentence": "We are excited to start",
      "wrong": ["is", "am", "were", "be"],
    },
    {
      "verb": "am not",
      "sentence": "I am not interested",
      "wrong": ["aren't", "isn't", "wasn't", "am"],
    },
    {
      "verb": "isn't",
      "sentence": "The book isn't expensive",
      "wrong": ["aren't", "am not", "wasn't", "is"],
    },
    {
      "verb": "aren't",
      "sentence": "They aren't from here",
      "wrong": ["isn't", "am not", "weren't", "are"],
    },
    {
      "verb": "I'm not",
      "sentence": "I'm not afraid of spiders",
      "wrong": ["is not", "aren't", "am", "was"],
    },
    {
      "verb": "you're",
      "sentence": "You're very kind",
      "wrong": ["is", "am", "were", "be"],
    },
    {
      "verb": "she's",
      "sentence": "She's my best friend",
      "wrong": ["is not", "are", "was", "be"],
    },
    {
      "verb": "it’s",
      "sentence": "It's very cold today",
      "wrong": ["isn't", "are", "was", "be"],
    },
    {
      "verb": "was",
      "sentence": "I was at the movies",
      "wrong": ["were", "am", "is", "be"],
    },
    {
      "verb": "was not",
      "sentence": "I was not ready",
      "wrong": ["were not", "is not", "am not", "was"],
    },
    {
      "verb": "were",
      "sentence": "You were great in the game",
      "wrong": ["was", "are", "is", "am"],
    },
    {
      "verb": "weren't",
      "sentence": "We weren't late for school",
      "wrong": ["wasn't", "aren't", "isn't", "were"],
    },
    {
      "verb": "will be",
      "sentence": "They will be famous one day",
      "wrong": ["are", "is", "was", "be"],
    },
    {
      "verb": "won't be",
      "sentence": "It won't be easy",
      "wrong": ["isn't", "wasn't", "aren't", "will be"],
    },
    {
      "verb": "is being",
      "sentence": "The teacher is being very strict",
      "wrong": ["are being", "was being", "is", "be"],
    },
    {
      "verb": "am being",
      "sentence": "I'm being careful with this",
      "wrong": ["is being", "are being", "am", "was"],
    },
    {
      "verb": "are being",
      "sentence": "They are being helpful",
      "wrong": ["is being", "am being", "are", "were"],
    },
    {
      "verb": "was being",
      "sentence": "She was being sarcastic",
      "wrong": ["is being", "were being", "was", "be"],
    },
    {
      "verb": "were being",
      "sentence": "You were being impatient",
      "wrong": ["was being", "are being", "were", "be"],
    },
    {
      "verb": "is",
      "sentence": "This is my favorite game",
      "wrong": ["are", "was", "be", "am"],
    },
    {
      "verb": "are",
      "sentence": "These are my friends",
      "wrong": ["is", "am", "were", "be"],
    },
    {
      "verb": "isn't",
      "sentence": "He isn't at home",
      "wrong": ["aren't", "wasn't", "is", "am not"],
    },
    {
      "verb": "aren't",
      "sentence": "We aren't hungry right now",
      "wrong": ["isn't", "am not", "weren't", "are"],
    },
    {
      "verb": "will be",
      "sentence": "The results will be ready soon",
      "wrong": ["was", "is", "are", "being"],
    },
    {
      "verb": "will not be",
      "sentence": "You will not be alone",
      "wrong": ["isn't", "wasn't", "aren't", "will be"],
    },
    {
      "verb": "he's",
      "sentence": "He's always on time",
      "wrong": ["is not", "are", "was", "be"],
    },
    {
      "verb": "we're",
      "sentence": "We're happy to see you",
      "wrong": ["is", "was", "won't", "were"],
    },
  ];
}
