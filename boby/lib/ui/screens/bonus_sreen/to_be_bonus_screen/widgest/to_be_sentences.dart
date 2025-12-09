class ToBeSentences {
  static List sentences = [
    // --- Presente Singular (is) ---
    {
      "verb": "is",
      "sentence": "The cat is small",
      "wrong": ["are", "am", "were", "been"],
    },
    {
      "verb": "is",
      "sentence": "The house is big",
      "wrong": ["are", "am", "were", "being"],
    },
    {
      "verb": "is",
      "sentence": "My father is tall",
      "wrong": ["are", "am", "were", "be"],
    },
    {
      "verb": "is",
      "sentence": "The baby is calm",
      "wrong": ["are", "am", "were", "been"],
    },
    {
      "verb": "is",
      "sentence": "The sun is bright today",
      "wrong": ["are", "am", "were", "being"],
    },

    // --- Presente Plural (are) ---
    {
      "verb": "are",
      "sentence": "The children are happy",
      "wrong": ["is", "am", "was", "been"],
    },
    {
      "verb": "are",
      "sentence": "The cars are fast",
      "wrong": ["is", "am", "was", "be"],
    },
    {
      "verb": "are",
      "sentence": "The dogs are outside",
      "wrong": ["is", "am", "was", "being"],
    },
    {
      "verb": "are",
      "sentence": "My friends are excited",
      "wrong": ["is", "am", "was", "be"],
    },
    {
      "verb": "are",
      "sentence": "The books are new",
      "wrong": ["is", "am", "was", "been"],
    },

    // --- Presente 1ª Persona (am) ---
    {
      "verb": "am",
      "sentence": "I am hungry",
      "wrong": [
        "is",
        "are",
        "were",
        "be",
      ], // Se eliminó "was" para evitar la ambigüedad temporal.
    },
    {
      "verb": "am",
      "sentence": "I am ready for school",
      "wrong": ["is", "are", "were", "been"], // Se eliminó "was".
    },
    {
      "verb": "am",
      "sentence": "I am very tired",
      "wrong": ["is", "are", "were", "be"],
    },
    {
      "verb": "am",
      "sentence": "I am at home",
      "wrong": ["is", "are", "were", "being"], // Se eliminó "was".
    },
    {
      "verb": "am",
      "sentence": "I am a good student",
      "wrong": ["is", "are", "were", "been"],
    },

    // --- Pasado Singular (was) ---
    {
      "verb": "was",
      "sentence": "The movie was funny",
      "wrong": [
        "were",
        "are",
        "am",
        "are not",
      ], // Se eliminó "be". Se añadió "is" y "are" para evitar ambigüedad de tiempo/número.
    },
    {
      "verb": "was",
      "sentence": "The boy was tired",
      "wrong": [
        "were",
        "are",
        "am",
        "are not",
      ], // Se eliminó "being". Se añadió "is" y "are".
    },
    {
      "verb": "was",
      "sentence": "The room was cold",
      "wrong": [
        "were",
        "are",
        "am",
        "are not",
      ], // Se eliminó "been". Se añadió "is" y "are".
    },
    {
      "verb": "was",
      "sentence": "The game was difficult",
      "wrong": ["were", "are", "am", "are not"],
    },
    {
      "verb": "was",
      "sentence": "The cake was delicious",
      "wrong": ["were", "are", "am", "are not"],
    },

    // --- Pasado Plural (were) ---
    {
      "verb": "were",
      "sentence": "The teachers were kind",
      "wrong": ["was", "is", "am", "be"],
    },
    {
      "verb": "were",
      "sentence": "The students were noisy",
      "wrong": ["was", "is", "am", "being"],
    },
    {
      "verb": "were",
      "sentence": "The toys were broken",
      "wrong": ["was", "is", "am", "been"],
    },
    {
      "verb": "were",
      "sentence": "My cousins were at the park",
      "wrong": [
        "was",
        "is",
        "am",
        "are",
      ], // "are" se mantiene porque al ser singular/pasado ("was", "is", "am") ya no hay ambigüedad.
    },
    {
      "verb": "were",
      "sentence": "The flowers were beautiful",
      "wrong": ["was", "is", "am", "be"], // Se eliminó el duplicado "am".
    },

    // --- Negativas Singular (is not / was not) ---
    {
      "verb": "is not",
      "sentence": "The water is not warm",
      "wrong": [
        "are not",
        "am not",
        "were not",
        "are",
      ], // "was not" se añade, ya que es la forma singular incorrecta por tiempo.
    },
    {
      "verb": "is not",
      "sentence": "The answer is not correct",
      "wrong": ["are not", "am not", "were not", "are"],
    },
    {
      "verb": "was not",
      "sentence": "The street was not empty",
      "wrong": [
        "were not",
        "are not",
        "am not",
        "are",
      ], // "is not" se añade, ya que es la forma singular incorrecta por tiempo.
    },
    {
      "verb": "was not",
      "sentence": "The box was not heavy",
      "wrong": ["were not", "are not", "am not", "are"],
    },

    // --- Negativas Plural (are not / were not) ---
    {
      "verb": "are not",
      "sentence": "The apples are not red",
      "wrong": [
        "is not",
        "am not",
        "was not",
        "will not",
      ], // Se añade "were not" como la forma plural incorrecta por tiempo.
    },
    {
      "verb": "are not",
      "sentence": "The chairs are not clean",
      "wrong": ["is not", "am not", "was not", "will not"],
    },
    {
      "verb": "were not",
      "sentence": "The kids were not quiet",
      "wrong": [
        "was not",
        "is not",
        "am not",
        "will not",
      ], // Se añade "are not" como la forma plural incorrecta por tiempo.
    },
    {
      "verb": "were not",
      "sentence": "The doors were not open",
      "wrong": ["was not", "is not", "am not", "will not"],
    },

    // --- Futuro (will be) ---
    {
      "verb": "will be",
      "sentence": "The test will be easy",
      "wrong": [
        "will",
        "being",
        "are not",
        "are",
      ], // Formas que rompen la estructura o no concuerdan.
    },
    {
      "verb": "will be",
      "sentence": "The room will be ready soon",
      "wrong": ["will", "being", "are", "am"],
    },
    {
      "verb": "will be",
      "sentence": "The project will be important",
      "wrong": ["will", "being", "were", "are"],
    },

    // --- Futuro Negativo (will not be) ---
    {
      "verb": "will not be",
      "sentence": "The task will not be hard",
      "wrong": ["were not", "being not", "are not", "am not"],
    },
    {
      "verb": "will not be",
      "sentence": "The result will not be fast",
      "wrong": ["will not", "been not", "are not", "were not"],
    },
  ];
}
