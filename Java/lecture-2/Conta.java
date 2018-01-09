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
		System.out.println("Saldo anterior (ANTES SAQUE): " + THIS.saldo);
		double novoSaldo = THIS.saldo - quantidade; //O THIS nos usamos quando quiser usar a referencia dentro do mesmo objeto. Ou seja, acessar os atributos da mesma instancia
		THIS.saldo = novoSaldo;
		System.out.println("Saldo posterior (DEPOIS SAQUE): " + THIS.saldo);

	}

	void deposita(double quantidade){
		System.out.println("Saldo anterior (ANTES DEPOSITO): " + THIS.saldo);
		THIS.saldo = THIS.saldo + quantidade;
		System.out.println("Saldo posterior (DEPOIS DEPOSITO): " + THIS.saldo);
	}

	void rendimento(double quantidade){
		System.out.println("Saldo anterior (ANTES RENDIMENTO): " + THIS.saldo);
		THIS.saldo = THIS.saldo * 0.1;
		System.out.println("Saldo posterior (DEPOIS RENDIMENTO): " + THIS.saldo);
	}

}
