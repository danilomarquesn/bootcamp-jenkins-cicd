### Sumário
1. [Sobre o projeto](#sobre-o-projeto)
1. [Preparando a estação de trabalho](#preparando-a-estação-de-trabalho)
1. [Inicializando o projeto](#inicializando-o-projeto)
1. [Jenkins](#jenkins)
1. [App Python](#app-python)

### Sobre o projeto
[[sumário](#sumário)]

Infraestrutura como código (terraform) para provisionar um **Jenkins-server** + **esteira CI/CD** no Jenkins capaz de **clonar repositório**, **provisionar infraestrutura** (através do terraform) e realizar o **deploy de uma aplicação** básica em Python. 

#### **Módulos**

> Todos os módulos utilizados no projeto fazem parte do Terraform Registry, e as documentações podem ser encontradas no seguinte link: **[Terraform Registry](https://registry.terraform.io/browse/modules)**
>
>> Módulos utilizados:
>> * [AWS VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
>> * [AWS EC2-VPC Security Group](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
>> * [AWS EC2 Instance](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/4.0.0)

```
Provider: AWS
Provider version = "4.17.1"
Region: US-EAST-2 (Ohio)
Terraform version: Terraform v1.1.7
```

#### **Docker Compose**
[Documentação de apoio](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04-pt)

#### **Jenkins Server**
[Documentação de apoio](https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code)

### Preparando a estação de trabalho
[[sumário](#sumário)]

1. [Configure o AWS CLI](https://aws.amazon.com/pt/cli/)

2. [Crie um usuário na sua conta AWS](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html)

3. Configure o seu “**aws configure**” na sua estação de trabalho

[Documentação de apoio](https://registry.terraform.io/providers/hashicorp/aws/3.71.0/docs)

**Linux e Windows:** 

```
$ aws configure
```

    1. AWS Access Key ID:
    2. AWS Secret Access Key:
    3. Default region name:
    4. Default output format:

Ou edite o arquivo _“**credentials**”_ gerado dentro do diretório _“.**aws**”_.

Caso utilize token adicione a linha abaixo no arquivo supracitado:

```
aws_session_token=TOKEN
```

**Linux**:

```
$ export AWS_ACCESS_KEY_ID="anaccesskey" 
$ export AWS_SECRET_ACCESS_KEY="asecretkey" 
$ export AWS_DEFAULT_REGION="us-east-2" 
$ terraform plan
```

**Windows**:
```
Set-Item -Path env:AWS_ACCESS_KEY_ID -Value 'anaccesskey' 
Set-Item -Path env:AWS_SECRET_ACCESS_KEY -Value 'asecretkey' 
Set-Item -Path env:AWS_REGION -Value 'us-east-2' 
```

### Inicializando o projeto
[[sumário](#sumário)]

1. Na sua conta AWS, crie um **bucket S3** para armazenamento do _tfstate_ (armazenamento remoto):

```
Bucket name: bootcamp-myawsbucket-tf-remote-state
AWS Region: US East (Ohio) us-east-2
```
Ou se preferir utilize a infraestrutura como código do diretório "**.remote-state**" contido neste projeto, através dos comandos: **terraform init**, **terraform plan** e **terraform apply**.

###### Aviso: Caso utilize outro nome ou região para o bucket S3, alterar o arquivo terraform.tf.

2. No console AWS, em EC2 > Network & Security (Segurança de Rede) > Key pairs (Pares de Chaves), clique em "Create Key Pair" (Criar Par de Chaves), e siga as informações abaixo:

```
Name: bootcamp
Key pair type: RSA 
Private key file format: .pem / .ppk (Windows)
- Tags
- Key: Name
- Value: bootcamp-keypair
```

###### Aviso: Não esqueça de adicionar a Tag "Name" com o valor "bootcamp" no momento da criação da key pair.

2.1. Salve a chave dentro do diretório do projeto.


3. No terminal, dentro do diretório do projeto, execute os seguintes comandos:

```
$ terraform init 
$ terraform plan
$ terraform apply -auto-approve
```

4. Na console da AWS, verifique o IP público atribuído a instância EC2 (**Public IPv4 address**), e abra no navegador:

```
http://seu_ip
```

5. A automação deste projeto configura as seguintes etapas do Jenkins:

```
Configuração do conta Admin Inicial (initialAdminPassword)
Instalar plugins sugeridos (Install suggested plugins)
```


### Jenkins
[[sumário](#sumário)]

1. Utilize o usuário e senha a seguir:

```
Nome do usuário:  admin
Senha: jenkins
```
###### Aviso: Como boa prática de segurança, não recomendamos que o usuário e senha do Jenkins esteja em _hard coded_. As informações estão no código apenas para efeito de estudo, por isso altere a senha assim que acessar o Jenkins pela primeira vez.
###### Aviso 2: Não disponibilize nenhuma informação do Jenkins ou da sua conta AWS em seu repositório.
###### Aviso 3: Caso deseje editar as credenciais de acesso do Jenkins, edite dentro do arquivo "dependencias.sh": linhas 44 e 45.


2. Agora vamos criar a pipeline responsável por criar a nova infraestrutura e realizar o deploy da aplicação Python:

```
Nova tarefa (New Item) >> 
Entre com o nome do item: Infraestrutura e Deploy (sugestão)
Pipeline >> 
All very well (tudo certo) >>
Na guia "Pipeline" : Pipeline script >> 
Copie e cole o conteúdo do arquivo "pipeline" que encontra-se no repositório >>
Em seguida, clique em "Salvar"
```

3. A Pipeline está criada! Clique em "**Construir agora**" (Build Now) e os seguintes passos serão percorridos pela esteira:

```
Clone 
```
###### **clone do [repositório](https://github.com/danilomarquesn/basic-python-app)**
```
TF Init&Plan
```
###### **terraform init e terraform plan**
```
Approval 
```
###### **Você deverá confirmar se deseja aplicar prosseguir com a criação da infraestrutura e deploy da aplicação.**
```
TF Apply
```
###### **terraform apply**

### App Python
[[sumário](#sumário)]

1. Note que uma nova instância EC2 foi criada na conta AWS.

```
python-application-server
```
2. Na console da AWS, verifique o IP público atribuído a instância EC2 (**Public IPv4 address**), adicione a porta **"5000"** e abra no navegador:

```
http://seu_ip:5000
```
3. A mensagem abaixo deverá estar disponível:

```
Bem-Vindo!!! Você já visitou esse site x vezes.
```
