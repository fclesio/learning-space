class Conta {
	//Como nao vamos executar nada, e precisamos apenas da representacao
	//do que e uma conta, entao nao teremos o main{}

	//O que a conta tem
	String titular;
	int numero;
	int agencia;
	Double saldo;
	String dataAniversario;

	//O que ela pode fazer
	void saca (double quantidade){
		System.out.println("Saldo anterior (ANTES SAQUE): " + this.saldo);
		double novoSaldo = this.saldo - quantidade; //O THIS nos usamos quando quiser usar a referencia dentro do mesmo objeto. Ou seja, acessar os atributos da mesma instancia
		this.saldo = novoSaldo;
		System.out.println("Saldo posterior (DEPOIS SAQUE): " + this.saldo);

	}

	void deposita(double quantidade){
		System.out.println("Saldo anterior (ANTES DEPOSITO): " + this.saldo);
		this.saldo = this.saldo + quantidade;
		System.out.println("Saldo posterior (DEPOIS DEPOSITO): " + this.saldo);
	}

	void rendimento(double quantidade){
		System.out.println("Saldo anterior (ANTES RENDIMENTO): " + this.saldo);
		this.saldo = this.saldo * 0.1;
		System.out.println("Saldo posterior (DEPOIS RENDIMENTO): " + this.saldo);
	}

}
