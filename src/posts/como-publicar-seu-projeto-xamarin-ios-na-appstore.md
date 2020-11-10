---
title: Como publicar seu projeto Xamarin.iOS na AppStore
description: Passo a passo de como eu consegui publicar um app Xamarin.iOS na
  AppStore sendo minha primeira experiencia com um mac.
author: Vinícius Hoyer
date: 2018-09-14T22:14:14.916Z
tags:
  - Tags
---
Third repost haha, first on [medium](https://medium.com/@vhoyer/como-publicar-seu-projeto-xamarin-ios-na-appstore-8925e7686af5), second on [dev.to](https://dev.to/vhoyer/como-publicar-seu-projeto-xamarin-ios-na-appstore-258), now here. Again, for historical reasons.

---

Tá, vamo lá. Primeiramente, gostaria de dizer que eu achei esse processo é bem mais complicado do precisava ser, mas quem sou eu, né? Outra coisa que eu achei muito complicado foi achar informações sobre como fazer isso, então eu to aqui e vou reportar meu processo de como eu consegui fazer isso.

Disclaimer: Eu tô escrevendo esse post enquanto faço o processo e é só minha segunda vez fazendo isso sendo que não lembro como fiz da primeira vez, então não tenho certeza de que todos os passos aqui descritos são realmente necessários, mas espero que funcione para você. Ah, e também é a terceira vez na vida que ponho a mão num mac, então perdoa o analfabetismo nessa questão 😜.

Esse post foi pensado por e para alguem que pouco uso um mac na vida, então você que já é iniciado nessa arte, favor ter piedade, tente dar umas risadas.

***

## Ferramentas: softwares e hardwares e versões e datas e etc…

Então, eu estou usando as seguintes ferramentas: um mac High Sierra versão 10.13.6; um iPhone (não sei qual o modelo, mas acho que não é relevante, você só vai precisar de um). Sobre as versões do software tente usar as mais recentes. Tenha em mente que esse processo funcionou para mim na data de 10 de Agosto de 2018.

Tu vais precisar ter uma conta da Apple que participa no programa de desenvolvedores. Vale lembrar que isso tem um custo

Primeira coisa é instalar o XCode no mac. Depois tu vai ter de aceitar a licença do xcode no terminal (espero que tu saiba tua senha):

```bash
sudo xcodebuild -license
```

Também vai precisar de um Visual Studio for mac instalado. Depois é sucesso. Acho.

### Depois de tudo instalado

Você vai precisar clonar o projeto em seu mac (sabe né? `git clone` _and stuff_), isso é, se ele já não estiver por aí. Com ele clonado, abra-o com o Visual Studio for Mac (VS apartir de agora).

Com ele aberto, boom, primeiro erro (pelo menos comigo). Mesmo selecionando para buildar o projeto de iOS, o VS está reclamando que eu não tenho o pacote do Android instalado; ok, instala-do. Mande _buildar_. Aparentemente o VS não baixa as dependencias NuGet sozinho por padrão, então clique com o botão direito na solução e procure por algo como “Restaurar Pacotes NuGet”.

_Ok Great_, o _debug_ abre no simulador. Agora a gente precisa fazer ele rodar no dispositivo físico, porque se não rodar nele, o app não vai para a AppStore (até porque você precisa fazer a build do pacote pelo iPhone).

Para que o mac consiga instalar o teu app no teu iPhone, tu vai precisar de algumas coisas.

- Um certificado com extensão .p12;
- um perfil de provisionamento (tradução livre de _provisioning profile_);
- um App Bundle ID.

Acho que é isso, vamo começar:

## Production Certificate .p12

Para esse passo, abra a caixa de pesquisa do mac (a lupa no canto superior direito) e digite “Acesso às Chaves”, o primeiro resultado deve ser o aplicativo, duh, “Acesso às Chaves”. Com ele aberto clique na barra superior em “Acesso às Chaves > Assistente de Certificado > Solicitar um certificado de uma autoridade de certificação…”.

Digite o email ao qual o certificado deve ser atrelado. Selecione “Salva no disco” e em “Continuar”. Selecione onde no computador o arquivo de Solicitação de assinatura de certificado (tradução livre de _Certificate Signing Request_ ou, apartir de agora, CSR) será salvo.

Abra o site https://developer.apple.com e depois clicar em account (para fazer o login). A conta que você vai utilizar precisa ser assinante daquele programa de desenvolvedores da Apple.

Logado vai procurar o “Certificates, Identifiers & Profiles” e clicar nele. Depois selecionar iOS, tvOS, watchOS e na categoria “Certificates”. Nessa tela você vai adicionar um novo certificado. Quando o site te perguntar qual o tipo de certicado que você precisa, tu vai escolher “App Store and AdHoc”, porque, afinal, tu estás tentando publicar o app na AppStore.

Aí “next”, “next”, e quando ele pedir para fazer o upload do arquivo CSR, tu escolhe aquele que você criou agora mais cedo. Aí “generate” e “download” e “Done”.

Com o arquivo .cer (que é o certificado) tu vai dar um _double-click_ nesse arquivo para instala-lo na utiliade de chaves. O nome dele vai ser parecido com “iPhone Distribution: <nome da conta> (<código de… algo>)” (como eu disse, estou longe de ser um especialista nesse assunto).

Para poder fazer o _debug_ num dispositivo físico (iPhone), repita o processo, porem ao invés de selecionar “App Store and AdHoc”, selecione “iOS App Development”. Para o _debug_ não vai ser necessário um arquivo .p12

Com o certificado instalado, a unica coisa que falta é exportar o certificado como um arquivo .p12 (aquilo que a gente tá precisando). Clicando com o botão direito no certificado e depois em exportar selecione o formato de arquivo para o .p12 e salva e é sucesso.

Nesse passo eu tive um problema em que essa opção estava bloqueada, aí eu tava procurando sobre como resolver esse problema por mais ou menos 1 hora, e quando eu fui tentar de novo ele funcionou… então fica a dica.

## App Bundle ID

Antes de qualquer outra coisa, tu vai precisar entrar (de novo) no https://developer.apple.com e depois, na categoria de identifiers, em “App IDs”. Lá tu vai colocar um App ID Description com o nome do app. Aí vem a parte do _App ID Suffix_, nessa parte voce lê bem e escolha a opção que melhor te comporta.

Vai clicando em “Next” até ter de clicar em “Register”, quando tu chegar nessa parte, tu vai saber que terminou de criar o ID. Depois de criar isso aí, tu vais ter de ir lá na no [iTunes Connect](http://appstoreconnect.apple.com/) aí logar com a mesma conta, entrar em “Meus aplicativos” e depois no botão de criar um novo aplicativo, nessa parte tu preenche os dados relativos à publicação e na área ID do pacote selecionar o ID que você acabou de criar no “App IDs”.

## Provisioning Profile

Para conseguir suas duas _provisioning profiles _ —  uma para _debug_ e uma para _release_  —  tu vai ter que voltar na developer.apple.com. Na navegação da página, procure por “Provisioning Profiles” e clique em “All”, Adicione uma nova selecionando a opção que melhor se encaixa nas suas necessidades (para mim foram iOS App Development, para desenvolvimento, e App Store para distribuição) e continue.

Aqui recomendo ler bem o que a apple tem a dizer sobre os _App IDs_ e as _provisioning profiles_ (dentro dessa página mesmo). Basicamente, se você precisa de notificações, do _game center_ ou de _In-App Purchase_, voce PRECISA especificar uma _provisioning profile_ para cada app que for usar essas funções, se não você pode usar o _wild card (*)_, pessoalmente, recomendo você criar uma _provisioning profile_ para cada App, para não ter dor de cabeça. Só clicar em _continue_.

Nesse passo você vai selecionar o certificado que você criou mais cedo. Provavelmente você só vai ter uma, a não ser que você tenha criado várias por engano 😜 ~~como eu fiz~~. _NEXT_!

Nesse passo, só colocar um nome para essa profile, _and be done with it_. Eu recomendo colocar um nome que identifique a _profile_ ao ler, exemplo: _release_APPBUNDLEID_, aí a parte do app bundleid tu substituie pelo teu, a não ser que seja wild card, nesse caso da pra usar um nome mais genérico, tipo _debug_generic_. Seja criativo, mantenha a leitura.

Seguindo para o próximo passo, baixe a profile, e clique em concluir, não esqueça de clicar em concluir. Repete o processo tanto para a profile de desenvolvimento quanto para a de distribuição.

Com as duas profiles criadas e baixadas, instale-as clicando duas vezes sobre cada uma. _It should be enought_.

Pronto, agora você pode começar a programar 💻😓. Programar? Não era só subir o app para a App Store? Bom… sim… a questão é: se tu vens programando esse app usando o windows e testando somente num dispositivo android, provavelmente — principalmente se é o seu primeiro app — vão existir vários erros no projeto. Se estiver com sorte, serão somente erros visuais.

***

## Quando o App estiver prontinho

Quando você estiver feliz com o resultado ou cansado de trabalhar naquela pilha de código que tu escreveu e já ta dizendo “é, acho que ta bom”, acho que tá na hora de fazer o upload desse seu app 😆.

Não se esqueça de preencher todos os espaços para imagem dentro do info.plist. Isso inclúi o arquivo .xcassets que é vinculado dentro do info.plsit. É, isso da um trabalho.

Abra o arquivo info.plist e selecione em “Assinando” o esquema “Provisionamento Manual” (eu tô usando o VS em pt-br, se o seu estiver em english, eu confio em você para inferir quais botões eles se referem kk sorry). Com isso selecionado, abra o “Bundle Signing Options…”.

Na tela que abriu, selecione a Identidade de Assinatura, abrir o dropdown vai te dar uma ideia sobre o que é isso, ou no mínimo da onde ele está vindo, mas acredito que é referente ao certificado que tu criou lá em cima. Seleciona, logo abaixo, o perfil de provisionamento que tu isntalou mais cedo (acho que nesse ponto você quer selecionar o de _release_). E terminar com o “Ok” ali em baixo, _all ready to go_.

E bom, se nada funcionou, você pode tentar selecionar “Provisionamento Automático” e tentar novamente ou nas configurações de bundle siging options o perfil de provisionamento automático. Vai experimentando até dar certo, até você não achar nenhum tutorial que te acomode na internet e resolver que você vai fazer um. Espero que você faça um melhor que o meu.

Com isso pronto e tudo tinindo, você vai clicar em “Compilar > Arquivo Morto para publicação”. Isso vai preparar um _snapshot_ do teu projeto e abrir uma tab com a lsitagem de todos os _snapshots_ com a ultima selecionada.

Daí tu clica em “Assinar e Distribuir…”, Vai no next next next, até ele te perguntar on salvar o arquivo (lembra de onde você salvou, você vai precisar dele daqui a pouco) aí tu salva, e clica em “Abrir carregador de aplicativo”.

Se não me engano aqui ele vai pedir pra tu _logar_ com tua conta do iTunesConnect, aí você entra 😉.

Double-click em “Deliver your app” escolhe o arquivo que você acabou de salvar. “Next”, tu espera ele fazer as coisas que ele faz, e depois clica em “next” e em seguida em “Done” e _Done_. Agora teu app está sendo processado pela AppStore e você vai poder gerenciar ele pela tua conta do iTunes Connect.

Se der algum erro nessa fase, voce vai la, procura na internet e tenta concertar, sorry nao poder ajudar aqui 😢. Se não der problema, entra lá no iTunes Connect que ainda pode dar erro por lá, porem se der erro lá ele te envia um email explicando o que estava errado e uma possível solução.

É, acho que é isso, sobre as configurações dentro do iTunes Connect não achei difícil entender muito o que esta acontecendo lá, mas pode ser só eu. Vou deixar os seguintes toques: Na tab “Atividades” sub-tab “Todas as compilações” você consegue ver qual o estado dos pacotes que você ta tentando sobir; O TestFlight é a mesma coisa que lançar o app em beta na qual só alguns usuários podem baixar. E eu tenho quase certeza de que você vai precisar de pelo menos uma screenshot do teu app por modelos suportado, ou seja, se tu estiver suportando tanto iPad quanto iPhone e iPhoneX, vai precisar de pelo menos três _screenshots_.

_Best regards_, boa sorte nessa empreitada. _Until next time_.