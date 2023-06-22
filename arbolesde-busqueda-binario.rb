class Nodo
  include Comparable

  attr_accessor :dato, :izquierdo, :derecho

  def initialize(dato)
    @dato = dato
    @izquierdo = nil
    @derecho = nil
  end

  def <=>(otro)
    @dato <=> otro.dato
  end
end

class Arbol
  attr_accessor :raiz

  def initialize(arr)
    arr_ordenado = arr.uniq.sort
    @raiz = construir_arbol(arr_ordenado)
  end

  def construir_arbol(arr)
    return nil if arr.empty?

    medio = arr.length / 2
    raiz = Nodo.new(arr[medio])

    raiz.izquierdo = construir_arbol(arr[0...medio])
    raiz.derecho = construir_arbol(arr[medio + 1..-1])

    raiz
  end

  def insertar(valor)
    nodo = Nodo.new(valor)
    return @raiz = nodo if @raiz.nil?

    actual = @raiz
    loop do
      if valor < actual.dato
        if actual.izquierdo.nil?
          actual.izquierdo = nodo
          break
        else
          actual = actual.izquierdo
        end
      else
        if actual.derecho.nil?
          actual.derecho = nodo
          break
        else
          actual = actual.derecho
        end
      end
    end
  end

  def eliminar(valor)
    @raiz = eliminar_nodo(@raiz, valor)
  end

  def eliminar_nodo(nodo, valor)
    return nodo if nodo.nil?

    if valor < nodo.dato
      nodo.izquierdo = eliminar_nodo(nodo.izquierdo, valor)
    elsif valor > nodo.dato
      nodo.derecho = eliminar_nodo(nodo.derecho, valor)
    else
      if nodo.izquierdo.nil? && nodo.derecho.nil?
        nodo = nil
      elsif nodo.izquierdo.nil?
        nodo = nodo.derecho
      elsif nodo.derecho.nil?
        nodo = nodo.izquierdo
      else
        nodo_minimo = encontrar_minimo(nodo.derecho)
        nodo.dato = nodo_minimo.dato
        nodo.derecho = eliminar_nodo(nodo.derecho, nodo_minimo.dato)
      end
    end

    nodo
  end

  def encontrar(valor)
    actual = @raiz
    while actual && actual.dato != valor
      if valor < actual.dato
        actual = actual.izquierdo
      else
        actual = actual.derecho
      end
    end
    actual
  end

  def recorrido_por_niveles
    cola = [@raiz]
    resultado = []

    until cola.empty?
      actual = cola.shift
      resultado << actual.dato if actual

      cola << actual.izquierdo if actual&.izquierdo
      cola << actual.derecho if actual&.derecho
    end

    resultado
  end

  def inorden(nodo = @raiz, resultado = [])
    return if nodo.nil?

    inorden(nodo.izquierdo, resultado)
    resultado << nodo.dato
    inorden(nodo.derecho, resultado)

    resultado
  end

  def preorden(nodo = @raiz, resultado = [])
    return if nodo.nil?

    resultado << nodo.dato
    preorden(nodo.izquierdo, resultado)
    preorden(nodo.derecho, resultado)

    resultado
  end

  def postorden(nodo = @raiz, resultado = [])
    return if nodo.nil?

    postorden(nodo.izquierdo, resultado)
    postorden(nodo.derecho, resultado)
    resultado << nodo.dato

    resultado
  end

  def altura(nodo = @raiz)
    return -1 if nodo.nil?

    altura_izquierdo = altura(nodo.izquierdo)
    altura_derecho = altura(nodo.derecho)

    [altura_izquierdo, altura_derecho].max + 1
  end

  def profundidad(nodo)
    return -1 if nodo.nil?

    actual = nodo
    contador = 0

    while actual != @raiz
      actual = padre(actual)
      contador += 1
    end

    contador
  end

  def equilibrado?(nodo = @raiz)
    return true if nodo.nil?

    altura_izquierdo = altura(nodo.izquierdo)
    altura_derecho = altura(nodo.derecho)

    return (altura_izquierdo - altura_derecho).abs <= 1 && equilibrado?(nodo.izquierdo) && equilibrado?(nodo.derecho)
  end

  def reequilibrar
    valores = []
    recorrido_por_niveles { |valor| valores << valor }
    @raiz = construir_arbol(valores)
  end

  private

  def padre(nodo)
    return nil if nodo == @raiz

    actual = @raiz
    padre = nil

    while actual && actual != nodo
      if nodo < actual
        padre = actual
        actual = actual.izquierdo
      else
        padre = actual
        actual = actual.derecho
      end
    end

    padre
  end

  def encontrar_minimo(nodo)
    actual = nodo
    actual = actual.izquierdo until actual.izquierdo.nil?
    actual
  end
end

# Método auxiliar para imprimir el árbol
def imprimir_bonito(nodo = @raiz, prefijo = '', es_izquierdo = true)
  return unless nodo

  imprimir_bonito(nodo.derecho, "#{prefijo}#{es_izquierdo ? '    ' : '│   '}", false)
  puts "#{prefijo}#{es_izquierdo ? '└── ' : '┌── '}#{nodo.dato}"
  imprimir_bonito(nodo.izquierdo, "#{prefijo}#{es_izquierdo ? '│   ' : '    '}", true)
end

# Crear un árbol de búsqueda binaria a partir de una matriz de números aleatorios
arr = Array.new(15) { rand(1..100) }
arbol = Arbol.new(arr)

# Comprobar si el árbol está equilibrado
puts "¿El árbol está equilibrado? #{arbol.equilibrado?}"

# Imprimir todos los elementos en orden de nivel, preorden, postorden y enorden
puts "Recorrido por niveles: #{arbol.recorrido_por_niveles.to_a}"
puts "Preorden: #{arbol.preorden.to_a}"
puts "Postorden: #{arbol.postorden.to_a}"
puts "Inorden: #{arbol.inorden.to_a}"

# Desbalancear el árbol agregando números > 100
arbol.insertar(101)
arbol.insertar(102)
arbol.insertar(103)

# Comprobar si el árbol está desequilibrado
puts "¿El árbol está desequilibrado? #{arbol.equilibrado?}"

# Reequilibrar el árbol
def reequilibrar
  valores = inorden # Esto recopilará los valores ordenados del árbol.
  @raiz = construir_arbol(valores)
end

# Comprobar si el árbol está equilibrado
puts "¿El árbol está equilibrado? #{arbol.equilibrado?}"

# Imprimir todos los elementos en orden de nivel, preorden, postorden y enorden
puts "Recorrido por niveles: #{arbol.recorrido_por_niveles.to_a}"
puts "Preorden: #{arbol.preorden.to_a}"
puts "Postorden: #{arbol.postorden.to_a}"
puts "Inorden: #{arbol.inorden.to_a}"
