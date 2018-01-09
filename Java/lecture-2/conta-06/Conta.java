class Conta {
	//Como nao vamos executar nada, e precisamos apenas da representacao
	//do que e uma conta, entao nao teremos o main{}

	//Atributos, o que a conta tem
	private String titular; // private e um	modificador	de	acesso
	private int numero;
	private int agencia;
	private double saldo;
	private Data dataAniversario = new Data(); //Criado o objeto para evitar Null Pointer exception
	private int identificador;

	//Como o nome nao e um atributo que queremos sempre alterar, nesse caso ele nao tera o set; e sim sera determinado no construtor.
	// public void setTitular(String titular){
	// 	this.titular = titular;
	// }	
	public String getTitular(){
		return this.titular;
	}
	public int getNumero(){
		return this.numero;	
	}
	public int getAgencia(){
		return this.agencia;
	}
	public double getSaldo(){
		return this.saldo;
	}
	public Data getDataAniversario(){
		return this.dataAniversario;
	}
	public int getIdentificador(){
		return this.identificador;
	}

	public Conta (String titular, int numero, int agencia, double saldo, int identificador){
		this.titular = titular;
		this.numero = numero;
		this.agencia = agencia;
		this.saldo = saldo;
		this.identificador = identificador;
	}


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

	double getRendimento(){ //Fica em branco pois ele nao recebe nenhum parametro	
		return this.saldo * 0.1;
	}

	String recuperaDados(){
		//Acessando o atributo e atribuit
		String dados = "Nome: " + this.titular + "\nNumero: " + this.numero + "\nAgencia: " + this.agencia + "\nDia:" + this.dataAniversario.dia + "\nMes:" + this.dataAniversario.mes + "\nAno:" + this.dataAniversario.ano; 		
		return dados;
	}

	void transfere(double valor, Conta destino){
		System.out.println("Saldo anterior (ANTES TRANSFERENCIA): " + this.saldo);
		this.saca(valor);
		destino.deposita(valor);
		System.out.println("Saldo posterior (DEPOIS TRANSFERENCIA): " + this.saldo);




	}

}
