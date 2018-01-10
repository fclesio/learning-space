package br.com.caelum.contas.modelo;

public class ContaCorrente extends Conta{
	@Override
	public void saca(double valor){
		this.saldo = this.saldo - (valor + 0.10);
	}
	
	
	
	public String getTipo(){
		return "Conta Corrente";
	}
	
	
}
