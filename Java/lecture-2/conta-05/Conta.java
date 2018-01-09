class Conta {
	//Como nao vamos executar nada, e precisamos apenas da representacao
	//do que e uma conta, entao nao teremos o main{}

	//Atributos, o que a conta tem
	String titular;
	int numero;
	int agencia;
	Double saldo;
	Data dataAniversario;

	//Comportamentos, isto e o que a classe pode fazer. 
	void saca(double valor){
		System.out.println("Saldo anterior (ANTES SAQUE): " + this.saldo);
		if(this.saldo >= valor){ //O THIS nos usamos quando quiser usar a referencia dentro do mesmo objeto. Ou seja, acessar os atributos da mesma instancia
			this.saldo = this.saldo - valor;
		}
		System.out.println("Saldo posterior (DEPOIS SAQUE): " + this.saldo);
	}

	void deposita(double valor){
		System.out.println("Saldo anterior (ANTES DEPOSITO): " + this.saldo);
		this.saldo = this.saldo + valor;
		System.out.println("Saldo posterior (DEPOIS DEPOSITO): " + this.saldo);
	}

	double calculaRendimento(){ //Fica em branco pois ele não recebe nenhum parâmetro	
		return this.saldo * 0.1;
	}

	String recuperaDados(){
		//Acessando o atributo e atribuit
		String dados = "Nome: " + this.titular + "\nNumero: " + this.numero + "\nAgencia: " + this.agencia;
		return dados;
	}


	void transfere(double valor, Conta destino){
		System.out.println("Saldo anterior (ANTES TRANSFERENCIA): " + this.saldo);
		this.saca(valor);
		destino.deposita(valor);
		System.out.println("Saldo posterior (DEPOIS TRANSFERENCIA): " + this.saldo);




	}

}
