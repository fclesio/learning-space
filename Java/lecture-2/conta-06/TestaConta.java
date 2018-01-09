class TestaConta{
	public static void main(String[] args) {
	
	//Criar uma nova conta com o nome c1. Conta = Classe
	Conta c1 = new Conta();

	//Preenchimento das informações da classe de acordo com os atributos dela
	c1.titular = "Flavio Clesio";
	c1.numero = 12345;
	c1.agencia = 54321;
	c1.saldo = 1000.0;
	c1.dataAniversario = "1985/01/12";

	c1.deposita(100.0);

	System.out.println("Saldo atual: " + c1.saldo);
	System.out.println("Rendimento mensal: " + c1.rendimento);


	}
}



	