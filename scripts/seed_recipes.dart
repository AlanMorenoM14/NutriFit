/// Script para poblar Firestore con recetas colombianas sencillas.
///
/// Uso:
///   1. Configura Firebase en tu proyecto (flutterfire configure)
///   2. Ejecuta: dart run scripts/seed_recipes.dart
///
/// Alternativamente, copia el JSON de las recetas directamente a la
/// consola de Firebase Firestore.

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Colombian recipes organized by meal type and goal.
final List<Map<String, dynamic>> recipes = [
  // ═══════════════════════════════════════════════════════════════
  // DESAYUNOS
  // ═══════════════════════════════════════════════════════════════
  {
    'title': 'Arepa con Huevo y Queso',
    'description': 'Arepa de maíz asada con huevo revuelto y queso campesino.',
    'imageUrl': '',
    'mealType': 'breakfast',
    'goals': ['gain_weight', 'maintain'],
    'calories': 420,
    'prepTimeMinutes': 15,
    'ingredients': [
      '1 arepa de maíz blanco',
      '2 huevos',
      '50g de queso campesino',
      'Sal al gusto',
      '1 cucharada de mantequilla',
    ],
    'steps': [
      'Asa la arepa en un sartén a fuego medio hasta que esté dorada por ambos lados.',
      'En otro sartén, derrite la mantequilla y revuelve los huevos con sal.',
      'Abre la arepa por la mitad y rellena con los huevos y el queso.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Changua',
    'description': 'Caldo boyacense de leche con huevo, ideal para las mañanas frías.',
    'imageUrl': '',
    'mealType': 'breakfast',
    'goals': ['maintain', 'lose_weight'],
    'calories': 220,
    'prepTimeMinutes': 15,
    'ingredients': [
      '1 taza de leche',
      '1 taza de agua',
      '1 huevo',
      '1 tallo de cebolla larga',
      'Cilantro fresco',
      'Sal al gusto',
    ],
    'steps': [
      'Hierve el agua con la leche y la cebolla larga picada.',
      'Cuando rompa a hervir, rompe el huevo directamente en la olla sin revolver.',
      'Cocina por 3 minutos, añade cilantro y sal. Sirve caliente.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Calentado Colombiano',
    'description': 'Arroz y fríjoles del día anterior salteados con huevo y arepa.',
    'imageUrl': '',
    'mealType': 'breakfast',
    'goals': ['gain_weight'],
    'calories': 550,
    'prepTimeMinutes': 10,
    'ingredients': [
      '1 taza de arroz del día anterior',
      '½ taza de fríjoles rojos',
      '2 huevos',
      '1 arepa',
      'Hogao (tomate y cebolla sofrita)',
      'Sal al gusto',
    ],
    'steps': [
      'Saltea el arroz y los fríjoles en un sartén con un poco de aceite por 5 minutos.',
      'Fríe los huevos aparte al gusto.',
      'Sirve el calentado con los huevos encima, hogao y la arepa al lado.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Avena Colombiana',
    'description': 'Avena cremosa con canela y panela, ligera y nutritiva.',
    'imageUrl': '',
    'mealType': 'breakfast',
    'goals': ['lose_weight', 'maintain'],
    'calories': 180,
    'prepTimeMinutes': 10,
    'ingredients': [
      '½ taza de avena en hojuelas',
      '1 taza de leche (o agua)',
      '1 cucharada de panela rallada',
      'Canela en polvo al gusto',
    ],
    'steps': [
      'Hierve la leche con la canela.',
      'Agrega la avena y cocina a fuego bajo revolviendo por 5 minutos.',
      'Endulza con panela rallada y sirve.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },

  // ═══════════════════════════════════════════════════════════════
  // ALMUERZOS
  // ═══════════════════════════════════════════════════════════════
  {
    'title': 'Arroz con Pollo',
    'description': 'Clásico arroz con pollo colombiano, completo y sustancioso.',
    'imageUrl': '',
    'mealType': 'lunch',
    'goals': ['gain_weight', 'maintain'],
    'calories': 520,
    'prepTimeMinutes': 30,
    'ingredients': [
      '1 pechuga de pollo',
      '1 taza de arroz',
      '½ zanahoria rallada',
      '¼ pimentón rojo picado',
      '1 diente de ajo',
      'Sal, comino y color al gusto',
    ],
    'steps': [
      'Cocina el pollo en agua con sal y comino. Desmenuza y reserva el caldo.',
      'Sofríe la zanahoria, pimentón y ajo. Agrega el arroz y sofríe 1 minuto.',
      'Añade el caldo (2 tazas por 1 de arroz), el pollo desmenuzado y el color.',
      'Cocina tapado a fuego bajo por 20 minutos.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Sopa de Lentejas',
    'description': 'Sopa espesa de lentejas con plátano verde, alta en proteína vegetal.',
    'imageUrl': '',
    'mealType': 'lunch',
    'goals': ['lose_weight', 'maintain'],
    'calories': 280,
    'prepTimeMinutes': 25,
    'ingredients': [
      '1 taza de lentejas',
      '½ plátano verde',
      '1 zanahoria',
      '1 papa',
      'Cebolla larga y cilantro',
      'Sal y comino al gusto',
    ],
    'steps': [
      'Remoja las lentejas 30 min. Cocina en agua con la zanahoria y papa picadas.',
      'Agrega el plátano verde picado en trozos.',
      'Cocina por 20 min hasta que todo esté blando. Añade hogao, cilantro y sal.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Sudado de Pollo',
    'description': 'Pollo guisado en salsa criolla con papa, plato colombiano por excelencia.',
    'imageUrl': '',
    'mealType': 'lunch',
    'goals': ['gain_weight', 'maintain'],
    'calories': 480,
    'prepTimeMinutes': 30,
    'ingredients': [
      '2 presas de pollo',
      '2 papas medianas',
      '1 tomate maduro',
      '1 cebolla cabezona',
      'Ajo, comino y color',
      'Sal al gusto',
    ],
    'steps': [
      'Sazona el pollo con ajo, comino, sal y color.',
      'En una olla, haz una cama con el tomate y la cebolla en rodajas.',
      'Coloca el pollo encima y las papas peladas. Tapa y cocina a fuego bajo por 25 min.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Ensalada de Pollo con Aguacate',
    'description': 'Ensalada fresca con pollo a la plancha y aguacate. Baja en calorías.',
    'imageUrl': '',
    'mealType': 'lunch',
    'goals': ['lose_weight'],
    'calories': 320,
    'prepTimeMinutes': 15,
    'ingredients': [
      '1 pechuga de pollo a la plancha',
      '½ aguacate',
      'Lechuga y tomate',
      'Limón y sal',
      'Aceite de oliva',
    ],
    'steps': [
      'Cocina la pechuga a la plancha con sal y pimienta. Corta en tiras.',
      'Arma la ensalada con lechuga, tomate y aguacate en rodajas.',
      'Coloca el pollo encima y aliña con limón y aceite de oliva.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },

  // ═══════════════════════════════════════════════════════════════
  // CENAS
  // ═══════════════════════════════════════════════════════════════
  {
    'title': 'Arepa con Hogao y Queso',
    'description': 'Arepa ligera con salsa hogao casera y queso rallado.',
    'imageUrl': '',
    'mealType': 'dinner',
    'goals': ['maintain', 'lose_weight'],
    'calories': 280,
    'prepTimeMinutes': 15,
    'ingredients': [
      '1 arepa de maíz',
      '1 tomate',
      '½ cebolla cabezona',
      'Queso rallado',
      'Aceite, sal y comino',
    ],
    'steps': [
      'Prepara hogao: sofríe la cebolla y el tomate picados con aceite, sal y comino.',
      'Asa la arepa hasta dorar.',
      'Sirve la arepa con hogao encima y queso rallado.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Caldo de Costilla',
    'description': 'Caldo reconfortante de costilla de res con papa, ideal para la cena.',
    'imageUrl': '',
    'mealType': 'dinner',
    'goals': ['gain_weight', 'maintain'],
    'calories': 380,
    'prepTimeMinutes': 25,
    'ingredients': [
      '200g de costilla de res',
      '2 papas medianas',
      '1 tallo de cebolla larga',
      'Cilantro fresco',
      'Sal y comino al gusto',
    ],
    'steps': [
      'Hierve la costilla en agua con cebolla larga y sal por 15 minutos.',
      'Agrega las papas peladas y cortadas. Cocina 10 minutos más.',
      'Sirve caliente con cilantro fresco picado.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Huevos Pericos',
    'description': 'Huevos revueltos colombianos con tomate y cebolla. Rápido y fácil.',
    'imageUrl': '',
    'mealType': 'dinner',
    'goals': ['lose_weight', 'maintain'],
    'calories': 200,
    'prepTimeMinutes': 8,
    'ingredients': [
      '2 huevos',
      '1 tomate pequeño picado',
      '¼ cebolla picada',
      'Sal al gusto',
      '1 cucharadita de aceite',
    ],
    'steps': [
      'Sofríe la cebolla y el tomate en aceite por 2 minutos.',
      'Agrega los huevos batidos con sal y revuelve hasta que cuajen.',
      'Sirve con arepa o pan.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Plátano Maduro con Queso',
    'description': 'Tajadas de plátano maduro frito con queso derretido. Contundente.',
    'imageUrl': '',
    'mealType': 'dinner',
    'goals': ['gain_weight'],
    'calories': 450,
    'prepTimeMinutes': 12,
    'ingredients': [
      '1 plátano maduro',
      '100g de queso mozzarella',
      'Aceite para freír',
      'Sal al gusto',
    ],
    'steps': [
      'Pela y corta el plátano en tajadas diagonales.',
      'Fríe en aceite caliente hasta dorar por ambos lados.',
      'Coloca el queso encima de las tajadas calientes para que se derrita.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },

  // ═══════════════════════════════════════════════════════════════
  // SNACKS
  // ═══════════════════════════════════════════════════════════════
  {
    'title': 'Empanadas Colombianas',
    'description': 'Empanadas de masa de maíz rellenas de carne y papa.',
    'imageUrl': '',
    'mealType': 'snack',
    'goals': ['gain_weight'],
    'calories': 350,
    'prepTimeMinutes': 25,
    'ingredients': [
      '1 taza de masa de maíz',
      '150g de carne molida',
      '1 papa cocida y machacada',
      'Hogao (tomate y cebolla)',
      'Aceite para freír',
      'Comino y sal',
    ],
    'steps': [
      'Sazona y cocina la carne molida con hogao y comino. Mezcla con la papa.',
      'Forma discos de masa, rellena y cierra en media luna.',
      'Fríe en aceite caliente hasta que estén doradas.',
    ],
    'difficulty': 'medium',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Patacones con Guacamole',
    'description': 'Tostones de plátano verde con guacamole fresco.',
    'imageUrl': '',
    'mealType': 'snack',
    'goals': ['gain_weight', 'maintain'],
    'calories': 300,
    'prepTimeMinutes': 15,
    'ingredients': [
      '1 plátano verde',
      '1 aguacate maduro',
      '½ tomate',
      'Limón, sal y cilantro',
      'Aceite para freír',
    ],
    'steps': [
      'Corta el plátano en rodajas gruesas, fríe, aplasta y fríe de nuevo.',
      'Prepara guacamole: tritura el aguacate con tomate picado, limón, sal y cilantro.',
      'Sirve los patacones con guacamole encima.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Fruta con Limón y Sal',
    'description': 'Mango o piña fresca con limón y un toque de sal. Snack ligero.',
    'imageUrl': '',
    'mealType': 'snack',
    'goals': ['lose_weight', 'maintain'],
    'calories': 80,
    'prepTimeMinutes': 5,
    'ingredients': [
      '1 mango maduro (o ½ piña)',
      'Jugo de 1 limón',
      'Sal al gusto',
    ],
    'steps': [
      'Pela y corta la fruta en trozos.',
      'Exprime el limón por encima y agrega un toque de sal.',
      'Sirve frío. ¡Listo!',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
  {
    'title': 'Agua de Panela con Limón',
    'description': 'Bebida colombiana refrescante de panela con limón. Sin azúcar añadida.',
    'imageUrl': '',
    'mealType': 'snack',
    'goals': ['lose_weight', 'maintain', 'gain_weight'],
    'calories': 90,
    'prepTimeMinutes': 5,
    'ingredients': [
      '1 trozo de panela (50g)',
      '2 tazas de agua',
      'Jugo de 1 limón',
      'Hielo',
    ],
    'steps': [
      'Disuelve la panela en agua (puedes calentarla para que se disuelva más fácil).',
      'Deja enfriar, agrega el limón y hielo.',
      'Sirve bien fría.',
    ],
    'difficulty': 'easy',
    'createdAt': FieldValue.serverTimestamp(),
  },
];

/// Sube las recetas a Firestore.
Future<void> seedRecipes() async {
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  print('🌱 Sembrando ${recipes.length} recetas colombianas...\n');

  for (final recipe in recipes) {
    final docRef = await firestore.collection('recipes').add(recipe);
    print('  ✅ ${recipe['title']} (${docRef.id})');
  }

  print('\n🎉 ¡Listo! ${recipes.length} recetas creadas exitosamente.');
}

void main() async {
  await seedRecipes();
}
