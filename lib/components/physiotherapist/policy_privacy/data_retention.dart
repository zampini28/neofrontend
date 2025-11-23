import 'package:flutter/material.dart';

class DataRetention extends StatelessWidget {
  const DataRetention({super.key});

  @override
  Widget build(BuildContext context) {
    Widget titleTopic({IconData? icon, required String title}) {
      return Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Theme.of(context).textTheme.labelLarge?.color,
            ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 300,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.labelLarge?.color,
              ),
            ),
          ),
        ],
      );
    }

    Widget textTopic({required String text}) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Theme.of(context).textTheme.labelLarge?.color,
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      spacing: 10,
      children: [
        titleTopic(title: 'Introdução'),
        textTopic(
          text:
              '''Bem-vindo(a) ao PhysioApp ("Plataforma"). A sua privacidade e a proteção dos seus dados pessoais são fundamentais para nós. Esta Política de Privacidade ("Política") descreve como nós, atuando como Controladores de seus dados, coletamos, utilizamos, armazenamos, compartilhamos e protegemos as informações de Fisioterapeutas e Pacientes ("Usuários" ou "Titulares") em estrita conformidade com a Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/2018 - "LGPD") e demais legislações aplicáveis, incluindo o Marco Civil da Internet (Lei nº 12.965/2014) e as resoluções dos Conselhos de Fisioterapia. Esta Plataforma lida com Dados Pessoais Sensíveis (dados de saúde), recebendo, portanto, o mais alto nível de proteção legal e técnica.''',
        ),
        titleTopic(
          title: 'Definições Chave (LGPD)',
          icon: Icons.key_rounded,
        ),
        textTopic(
          text:
              '''Para os fins desta política, considera-se:a) Titular: Pessoa natural a quem se referem os dados pessoais (o Fisioterapeuta ou o Paciente); b) Controlador: O PhysioApp, responsável pelas decisões referentes ao tratamento dos dados; c) Operador: Terceiro que realiza o tratamento de dados em nome do Controlador (ex: provedores de nuvem); d) Dados Pessoais: Informação que identifica ou torna identificável uma pessoa (ex: nome, e-mail, IP); e) Dados Pessoais Sensíveis: Dados sobre origem racial ou étnica, convicção religiosa, opinião política, filiação a sindicato ou a organização de caráter religioso, filosófico ou político, dado referente à saúde ou à vida sexual, dado genético ou biométrico (Art. 5º, II, LGPD); f) Tratamento: Toda operação realizada com dados pessoais (coleta, armazenamento, compartilhamento, exclusão, etc.).''',
        ),
        titleTopic(
          title: 'Tratamento de Dados Pessoais Coletados',
          icon: Icons.admin_panel_settings_rounded,
        ),
        textTopic(
          text:
              '''Coletamos apenas os dados estritamente necessários para a operação da Plataforma: Dados Cadastrais (Todos os Usuários): Nome completo, endereço de e-mail e senha de acesso criptografada. Dados de Verificação Profissional (Exclusivo para Fisioterapeutas): Número de registro no Conselho Regional de Fisioterapia e Terapia Ocupacional (CREFITO) e foto de perfil (opcional). Dados Pessoais Sensíveis (Conteúdo de Saúde): O conteúdo integral das comunicações via chat e o fluxo de áudio e vídeo das videochamadas realizadas entre Paciente e Fisioterapeuta; planos de tratamento, exercícios, avaliações, anotações e outros dados de saúde inseridos pelo Fisioterapeuta.  Dados Coletados mediante Consentimento Específico: Localização (GPS) para cadastro de clínica ou solicitação de atendimento domiciliar; acesso à Câmera e Microfone para execução das funcionalidades de videochamada e envio de fotos. Registros Técnicos e de Acesso: Endereço de Protocolo de Internet (IP), data, hora e atividade realizada na aplicação (logs). ''',
        ),
        titleTopic(
          title: 'Finalidades e Base Legal do Tratamento',
          icon: Icons.account_balance_rounded,
        ),
        textTopic(
          text:
              '''O tratamento de dados realizado pelo PhysioApp fundamenta-se nas seguintes bases legais da LGPD: a) Para Execução de Contrato (Art. 7º, V): Prestar o serviço principal, autenticar o acesso e prestar suporte técnico. b) Para Cumprimento de Obrigação Legal ou Regulatória (Art. 7º, II) e Exercício Regular de Direitos (Art. 7º, VI): Utilizar o CREFITO para validação profissional junto ao Conselho Regional; reter prontuários pelo prazo legal obrigatório; e manter logs de acesso por 6 meses (Marco Civil da Internet). c) Para Proteção da Vida e Tutela da Saúde (Art. 7º, VII e VIII, e Art. 11, "e" e "f"): Todo o tratamento de dados sensíveis para assistência à saúde. d) Mediante Consentimento (Art. 7º, I): Para o acesso à câmera, microfone e dados de localização. ''',
        ),
        titleTopic(
          title: 'Compartilhamento e Transferência de Dados',
          icon: Icons.folder_shared_rounded,
        ),
        textTopic(
          text:
              '''O PhysioApp não comercializa, aluga ou vende dados pessoais de Usuários para terceiros com fins de marketing ou publicidade. O compartilhamento de dados é restrito e ocorre apenas nas seguintes hipóteses: a) Conselhos Profissionais (Verificação): O número CREFITO e dados de identificação serão compartilhados com o respectivo Conselho Regional para validação inicial e revalidações periódicas (1 a 6 meses). b) Entre as Partes (Paciente e Fisioterapeuta): A Plataforma foi desenhada para compartilhar os dados de perfil e saúde do Paciente exclusivamente com o Fisioterapeuta por ele escolhido. c) Operadores Tecnológicos (Terceiros): Utilizamos prestadores de serviços (Operadores) para a infraestrutura tecnológica (hospedagem em nuvem, APIs de videochamada), sob rigorosas obrigações de confidencialidade. d) Requisição Legal ou Judicial: Poderemos compartilhar dados em caso de ordem judicial válida ou requisição de autoridade competente. ''',
        ),
        titleTopic(
            title: 'Retenção e Término do Tratamento',
            icon: Icons.rule_folder_rounded),
        textTopic(
          text:
              '''Os dados serão retidos pelo período mínimo necessário. Os Dados Cadastrais serão mantidos enquanto a conta estiver ativa e, após a exclusão, serão eliminados ou anonimizados. Os Dados Pessoais Sensíveis (Prontuário), incluindo mensagens e exercícios, serão mantidos em regime de bloqueio pelo prazo mínimo obrigatório definido pela legislação de saúde (podendo variar de 10 a 20 anos), mesmo após a exclusão da conta. Os Logs Técnicos serão mantidos por 6 meses. ''',
        ),
        titleTopic(
          title: 'Segurança da Informação',
          icon: Icons.security_rounded,
        ),
        textTopic(
          text:
              '''Adotamos medidas de segurança técnicas e administrativas avançadas para proteger os dados pessoais e sensíveis, incluindo criptografia em trânsito e em repouso, controle de acesso restrito e monitoramento de segurança, visando prevenir o acesso não autorizado, a destruição, perda ou alteração dos dados. ''',
        ),
        titleTopic(
          title: 'Direitos do Titular (ART. 18, LGPD)',
          icon: Icons.balance_rounded,
        ),
        textTopic(
          text:
              '''Garantimos ao Titular o pleno exercício dos seus direitos, mediante requisição: Confirmação da existência de tratamento; Acesso aos dados; Correção de dados; Anonimização, bloqueio ou eliminação de dados desnecessários (ressalvando-se a obrigação legal de retenção); Portabilidade; Eliminação dos dados tratados com o consentimento (exceto obrigações legais); Informação sobre compartilhamento; e Revogação do consentimento.\n\nObservação sobre a Correção do CREFITO: A alteração do número de registro CREFITO, por razões de segurança, só será realizada mediante solicitação formal, acompanhada de documentação comprobatória da mudança. ''',
        ),
        titleTopic(
            title: 'Encarregado pela Proteção de Dados (DPO)',
            icon: Icons.supervised_user_circle_rounded),
        textTopic(
          text:
              '''Para o exercício dos seus direitos e para esclarecimentos sobre esta Política, o PhysioApp nomeia um Encarregado pela Proteção de Dados (DPO), que pode ser contatado pelo e-mail: privacidade@physioapp.com.br. ''',
        ),
        titleTopic(
          title: 'Alterações desta Política',
          icon: Icons.update_rounded,
        ),
        textTopic(
          text:
              '''Reservamo-nos o direito de atualizar esta Política de Privacidade a qualquer tempo. Alterações significativas serão comunicadas aos Usuários através do aplicativo ou do e-mail cadastrado. ''',
        ),
      ],
    );
  }
}
