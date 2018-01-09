class Programa{
	public static void main(String[] args) { //Main = onde vamos executar as coisas
	
	Conta conta = new Conta("Duke",12345,54321,0.0,1);	
	Conta c1 = new Conta("Flavio",123,456,0.0,1);
	Conta c2 = new Conta("Clesio",789,012,0.0,1);

	//Colocando valores no conta
	// conta.titular = "Duke";
	// conta.saldo = 1000000.0;
	// conta.numero = 12345;
	// conta.agencia = 54321;

	//Nesse caso criamos a classe Dia.java e como usamos o atributo dataAniversario da classe Conta e passamos a Data como tipo (linha 10)
	// conta.dataAniversario.dia = 9;
	// conta.dataAniversario.mes = 1;
	// conta.dataAniversario.ano = 2017;

	conta.saca(100.0);
	conta.deposita(1000.0);

	c1.saca(100.0);
	c1.deposita(1000.0);

	c2.saca(100.0);
	c2.deposita(1000.0);

	System.out.println("Saldo atual: " + conta.getSaldo());
	System.out.println("Rendimento atual: " + conta.getRendimento());
	System.out.println("Saldo atual depois do rendimento: " + conta.getSaldo());
	System.out.println("Cliente: " + conta.recuperaDados());
	
	
	System.out.println("Saldo atual: " + c1.getSaldo());
	System.out.println("Rendimento atual: " + c1.getRendimento());
	System.out.println("Saldo atual depois do rendimento: " + c1.getSaldo());
	System.out.println("Cliente: " + c1.recuperaDados());


	System.out.println("Saldo atual: " + c2.getSaldo());
	System.out.println("Rendimento atual: " + c2.getRendimento());
	System.out.println("Saldo atual depois do rendimento: " + c2.getSaldo());
	System.out.println("Cliente: " + c2.recuperaDados());

	}
}
