package br.com.caelum.contas.modelo;
public class Conta {
	private String titular;
	private int numero;
	private String agencia;
	private double saldo;
	public String getTitular() {
		return titular;
	}
	public void setTitular(String titular) {
		this.titular = titular;
	}
	public int getNumero() {
		return numero;
	}
	public void setNumero(int numero) {
		this.numero = numero;
	}
	public String getAgencia() {
		return agencia;
	}
	public void setAgencia(String agencia) {
		this.agencia = agencia;
	}
	public double getSaldo() {
		return saldo;
	}
	public void deposita(double valor) {
		this.saldo = this.saldo + valor;		
	}
	public boolean saca(double valor) {
		if (this.saldo >= valor) {
			this.saldo = this.saldo - valor; 
			return true;			
		}			
		return false;
	}

		
	
	
	
	
}
