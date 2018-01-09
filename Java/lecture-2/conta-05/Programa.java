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

	//Nesse caso criamos a classe Dia.java e como usamos o atributo dataAniversario da classe Conta e passamos a Data como tipo (linha 10)
	conta.dataAniversario.dia = "9";
	conta.dataAniversario.mes = "1";
	conta.dataAniversario.ano = "2017";

	conta.saca(100.0);
	conta.deposita(1000.0);

	System.out.println("Saldo atual: " + conta.saldo);
	System.out.println("Rendimento atual: " + conta.calculaRendimento());
	System.out.println("Saldo atual depois do rendimento: " + conta.saldo);
	System.out.println("Cliente: " + conta.recuperaDados());


	Conta c1 = new Conta();
	Conta c2 = new Conta();	

	//Colocando valores na nova conta (cria um objeto novo na memoria com outro registro de memoria)
	c1.titular = "Flavio";
	c1.saldo = 10000.0;
	c1.numero = 54321;
	c1.agencia = 12345;
	//c1.dataAniversario = "1900/01/12";
	c1.dataAniversario.dia = "9";
	c1.dataAniversario.mes = "1";
	c1.dataAniversario.ano = "2017";



	//Colocando valores na nova conta (cria um objeto novo na memoria com outro registro de memoria)
	c2.titular = "Flavio";
	c2.saldo = 10000.0;
	c2.numero = 54321;
	c2.agencia = 12345;
	//c2.dataAniversario = "1900/01/12";
	c2.dataAniversario.dia = "9";
	c2.dataAniversario.mes = "1";
	c2.dataAniversario.ano = "2017";


	if (c1.titular == c2.titular) {
		System.out.println("Iguais");		
	} else {
		System.out.println("Diferentes");
	}	

	conta.transfere(100000,c1);


	}
}
