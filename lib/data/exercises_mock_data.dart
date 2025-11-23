import 'package:flutter/material.dart';
import 'package:physioapp/model/exercises/category.dart';
import 'package:physioapp/model/exercises/exercise.dart';

class ExercisesMockData {
  static const List<Category> categoryList = [
    Category(
      id: CategoryId.legs,
      title: 'Pernas',
      subtitle: 'Exercícios para trabalhar os quadriceps e posteriores',
      color: Color.fromARGB(255, 255, 168, 117),
    ),
    Category(
      id: CategoryId.abdominal,
      title: 'Abdominal',
      subtitle: 'Exercícios para trabalhar a região abdominal',
      color: Colors.pink,
    ),
    Category(
      id: CategoryId.back,
      title: 'Costas',
      subtitle: 'Exercícios para trabalhar a região das costas e lombar',
      color: Colors.pinkAccent,
    ),
    Category(
      id: CategoryId.arms,
      title: 'Braços',
      subtitle: 'Exercícios para trabalhar o braço e antebraço',
      color: Color.fromARGB(255, 56, 163, 165),
    ),
    Category(
      id: CategoryId.favorites,
      title: 'Favoritos',
      subtitle: 'Exercícios favoritados pelo Fisioterapeuta',
      color: Colors.redAccent,
    ),
    Category(
      id: CategoryId.personalized,
      title: 'Personalizados',
      subtitle: 'Exercícios adicionados pelo fisioterapeuta',
      color: Colors.amberAccent,
    ),
  ];

  List<Exercise> exercisesList = [
    Exercise(
      id: 'e1',
      name: 'Esticada de Perna (Quadriceps)',
      description:
          'Exercício para alongar as articulações das pernas, melhorando a mobilidade',
      videoUrl: '',
      videoDuration: 25.3,
      steps: [
        {
          'Posição Corporal':
              'Deite-se em um local plano que possa estabilizar seu corpo'
        },
        {
          'Movimento do Exercício':
              'Com o corpo deitado de bruços, estique uma perna para cima, mantendo-a esticada'
        },
        {
          'Manter Posição':
              'Mantenha a posição por 1 minutos e após isso abaixe a perna lentamente'
        },
        {
          'Trocar Perna':
              'Estique a outra perna e eleve-a o maximo que conseguir, mantendo-a esticada'
        },
        {
          'Manter Posição':
              'Mantenha a posição por 1 minutos e após isso abaixe a perna lentamente'
        },
      ],
      categoryId: [CategoryId.legs, CategoryId.back],
    ),
    Exercise(
      id: 'e2',
      name: 'Dobra de Perna (Joelho)',
      description:
          'Exercício para alongar as articulações do joelho, auxiliando assim na rotação da perna',
      videoUrl: '',
      videoDuration: 21.3,
      steps: [
        {
          'Posição Corporal':
              'Deite-se em um local plano que possa estabilizar seu corpo'
        },
        {
          'Movimento do Exercício':
              'Com o corpo deitado de costas, estique uma perna para cima, mantendo-a esticada'
        },
        {
          'Dobrar Joelho':
              'Quando a perna estiver esticada, dobre o joelho deixando a perna em um angulo de 90 graus'
        },
        {
          'Trocar Perna':
              'Estique a outra perna e eleve-a o maximo que conseguir, mantendo-a esticada'
        },
        {
          'Dobrar Joelhos':
              'Quando a perna estiver esticada, dobre o joelho deixando a perna em um angulo de 90 graus'
        },
        {
          'Abaixar perna': 'Abaixe a perna lentamente e deixe as duas esticadas'
        },
      ],
      categoryId: [
        CategoryId.legs,
        CategoryId.back,
        CategoryId.abdominal,
      ],
    ),
    Exercise(
      id: 'e3',
      name: 'Alogamento a Fundo (Posterior)',
      description:
          'Exercício para alongar as articulações das costas e membros inferiores',
      videoUrl: '',
      videoDuration: 13.3,
      steps: [
        {
          'Posição Corporal':
              'Sente-se em um local reto, incline-se em 45 graus para trás, mantendo-se sentado'
        },
        {
          'Movimento do Exercício':
              'Com auxílio de um objeto eleve a perna em um angulo pouco acima do chão e mantenha-a esticada'
        },
        {
          'Manter Posição':
              'Mantenha a posição por 1 minutos e após isso abaixe a perna lentamente'
        },
        {
          'Trocar Perna':
              'Com auxílio de um objeto eleve a perna em um angulo pouco acima do chão e mantenha-a esticada'
        },
        {
          'Manter Posição':
              'Mantenha a posição por 1 minutos e após isso abaixe a perna lentamente'
        },
      ],
      categoryId: [
        CategoryId.legs,
        CategoryId.back,
        CategoryId.abdominal,
      ],
    ),
    Exercise(
      id: 'e4',
      name: 'Puxada Funda no Triceps Sural',
      description:
          'Exercício para trabalhar as articulações das costas e aumentar a flexibilidade das pernas',
      videoUrl: '',
      videoDuration: 15.3,
      steps: [
        {
          'Posição Corporal':
              'Sente-se em um local reto com pelo menos 90 centimetros do chão'
        },
        {
          'Movimento do Exercício':
              'Incline o corpo em um angulo de 45 graus para frente'
        },
        {
          'Estique a perna':
              'Com o corpo para frente, mantenha a perna esticada'
        },
        {'Relaxar Corpo': 'Volte para a posição inicial'},
        {
          'Troque de Perna':
              'Com o corpo para frente, mantenha a perna esticada'
        },
      ],
      categoryId: [CategoryId.legs, CategoryId.back, CategoryId.abdominal],
    ),
    Exercise(
      id: 'e5',
      name: 'Alogamento Posteiror Completa',
      description:
          'Exercício para alongar as articulações lombares, abdominais, membros inferiores e superiores',
      videoUrl: '',
      videoDuration: 17.3,
      steps: [
        {'Posição Corporal': 'Fique de quatro sobre uma superficie reta'},
        {
          'Movimento do Exercício':
              'Levante o braço esquerdo e a perna direita e mantenha-os elevados'
        },
        {
          'Manter Posição':
              'Mantenha a posição por 30 segundos e após isso abaixe a perna e o braço lentamente'
        },
        {
          'Trocar Posição':
              'Levante o braço direito e a perna esquerda e mantenha-os elevados'
        },
        {
          'Manter Posição':
              'Mantenha a posição por 30 segundos e após isso abaixe a perna e o braço lentamente'
        },
      ],
      categoryId: [
        CategoryId.legs,
        CategoryId.back,
        CategoryId.abdominal,
        CategoryId.arms,
      ],
    ),
    Exercise(
      id: 'e6',
      name: 'Fortalecimento (Corpo Inteiro)',
      description:
          'Exercício fortalecer as principais articulações dos membros superiores, inferiores e posteriores',
      videoUrl: '',
      videoDuration: 20.3,
      steps: [
        {'Posição Corporal': 'Fique de quatro sobre uma superficie reta'},
        {
          'Movimento do Exercício':
              'deixe suas pernas juntas, e icline-se com seus braços juntos para frente o máximo que conseguir'
        },
        {
          'Manter Posição':
              'Mantenha a posição por 10 segundos e após isso volte lentamente a posição inicial'
        },
        {
          'Repetir Movimento':
              'deixe suas pernas juntas, e icline-se com seus braços juntos para frente o máximo que conseguir'
        },
      ],
      categoryId: [
        CategoryId.legs,
        CategoryId.back,
        CategoryId.abdominal,
        CategoryId.arms,
      ],
    ),
  ];
}
