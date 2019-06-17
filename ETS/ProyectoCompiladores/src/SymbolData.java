/*
Piste Gomez Cristian Jovani
3CV5
Proyecto para ETS Ordinario de compiladores
Interprete Mini-Logo
17/06/2019
Compiladores
*/
public class SymbolData {

    private String nombre;
    private Object objeto;

    public SymbolData(String nombre, Object objeto){
        this.nombre = nombre;
        this.objeto = objeto;
    }
    
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Object getObjeto() {
        return objeto;
    }

    public void setObjeto(Object objeto) {
        this.objeto = objeto;
    }
        
}
