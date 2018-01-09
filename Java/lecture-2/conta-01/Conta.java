class Conta {
	//Como nao vamos executar nada, e precisamos apenas da representacao
	//do que e uma conta, entao nao teremos o main{}

	//Atributos, o que a conta tem
	String titular;
	int numero;
	int agencia;
	Double saldo;
	String dataAniversario;

	//Comportamentos, isto e o que a classe pode fazer. 
	void saca (double valor){
		System.out.println("Saldo anterior (ANTES SAQUE): " + this.saldo);
		if(this.saldo >= valor){ //O THIS nos usamos quando quiser usar a referencia dentro do mesmo objeto. Ou seja, acessar os atributos da mesma instancia
			this.saldo = this.saldo - valor
		}
		System.out.println("Saldo posterior (DEPOIS SAQUE): " + this.saldo);
	}

	void deposita(double valor){
		System.out.println("Saldo anterior (ANTES DEPOSITO): " + this.saldo);
		this.saldo = this.saldo + valor;
		System.out.println("Saldo posterior (DEPOIS DEPOSITO): " + this.saldo);
	}

	double calculaRendimento(){ //Fica em branco pois ele não recebe nenhum parâmetro
		System.out.println("Saldo anterior (ANTES RENDIMENTO): " + this.saldo);
		return this.saldo * 0.1;
		System.out.println("Saldo posterior (DEPOIS RENDIMENTO): " + this.saldo);
	}

}
