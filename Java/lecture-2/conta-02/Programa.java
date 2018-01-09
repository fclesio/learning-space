class Programa{
	public static void main(String[] args) { //Main = onde vamos executar as coisas
	
	//Conta minhaConta; //Essa eh a referencia da classe Conta que sera armazenada em um objeto chamado minhaConta
	//minhaConta = new Conta(); //Para criar uma conta nova basta usar a palavra new()
	
	Conta conta = new Conta();	

	//Colocando valores no conta
	conta.titular = "Duke";
	conta.saldo = 1000000.0;
	conta.numero = 12345;
	conta.agencia = 54321;
	conta.dataAniversario = "1985/01/12";

	conta.saca(100.0);
	conta.deposita(1000.0);

	System.out.println("Saldo atual: " + conta.saldo);
	System.out.println("Rendimento atual: " + conta.calculaRendimento());
	System.out.println("Saldo atual depois do rendimento: " + conta.saldo);
	System.out.println("Cliente: " + conta.recuperaDados());


	}
}
