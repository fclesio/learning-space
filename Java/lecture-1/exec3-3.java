class BalancoTrimestral{
	public static void main(String[] args) {
		//System.out.print("Olá Mundo!\nHello World!\n");
		//System.out.println("Olá Mundo!");		
		int gastosJaneiro = 15000;
		int gastosFevereiro = 23000;
		int gastosMarco = 17000;
		
		int gastosTrimestre = gastosJaneiro + gastosFevereiro + gastosMarco;
		int mediaMensal = (gastosJaneiro + gastosFevereiro + gastosMarco)/3;

		System.out.println("Os gastos do trimestre foram: R$"+ gastosTrimestre + ".");
		System.out.println("A media do trimestre foi: R$"+ mediaMensal + ".");

	}
}
