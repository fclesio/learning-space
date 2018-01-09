class TestaAlgunsMetodos{
	public static void main(String[] args) {
	
	Conta minhaConta; //Essa eh a referencia da classe Conta que sera armazenada em um objeto chamado minhaConta
	minhaConta = new Conta();//Para criar uma conta nova basta usar a palavra new()
	
	//Colocando valores no minhaConta
	minhaConta.titular = "Duke";
	minhaConta.saldo = 1000.0;

	//Sacando 200 reais
	minhaConta.saca(200);

	//Deposita 500 reais
	minhaConta.deposita(500);
	System.out.println(minhaConta.saldo);

	}
}



	
