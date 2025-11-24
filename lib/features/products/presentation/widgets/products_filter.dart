import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';

class ProductFilter extends StatefulWidget {
  const ProductFilter({Key? key}) : super(key: key);

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;

  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  // ✅ Lista de categorias normalizadas (baseada nos seus dados reais)
  final List<String> _categories = [
    'Eletrônicos',
    'Roupas',
    'Livros',
    'Casa',
    'Esportes',
    'Beleza',
    'Brinquedos',
    'Alimentos',
    // Categorias do fornecedor brasileiro
    'Grocery',
    'Tools',
    'Outdoors',
    'Games',
    'Books',
    'Computers',
    'Music',
    'Clothing',
    'Health',
    'Garden',
    'Shoes',
    'Baby',
    'Kids',
    'Home',
    'Jewelery',
    'Toys',
    'Industrial',
    'Movies',
    'Beauty',
    'Electronics',
    'Sports',
  ]..sort(); // Ordena alfabeticamente

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    // Parse dos valores de preço
    _minPrice = _minPriceController.text.isNotEmpty
        ? double.tryParse(_minPriceController.text.replaceAll(',', '.'))
        : null;
    _maxPrice = _maxPriceController.text.isNotEmpty
        ? double.tryParse(_maxPriceController.text.replaceAll(',', '.'))
        : null;

    // Validação básica
    if (_minPrice != null && _maxPrice != null && _minPrice! > _maxPrice!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preço mínimo não pode ser maior que o máximo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('🔍 Aplicando filtros:');
    print('   - Busca: ${_searchController.text}');
    print('   - Categoria: $_selectedCategory');
    print('   - Min: $_minPrice');
    print('   - Max: $_maxPrice');

    context.read<ProductsBloc>().add(
          FilterProductsEvent(
            searchQuery: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
            category: _selectedCategory,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
          ),
        );
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedCategory = null;
      _minPrice = null;
      _maxPrice = null;
    });
    context.read<ProductsBloc>().add(const ResetFilters());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Título
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Limpar tudo'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Busca por nome
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar produto',
                        hintText: 'Nome ou descrição',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Categoria
                    Text(
                      'Categoria',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text('Selecione uma categoria'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todas as categorias'),
                        ),
                        ..._categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Faixa de preço
                    Text(
                      'Faixa de Preço',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Mínimo',
                              prefixText: 'R\$ ',
                              border: OutlineInputBorder(),
                              hintText: '0.00',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Máximo',
                              prefixText: 'R\$ ',
                              border: OutlineInputBorder(),
                              hintText: '9999.00',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Digite valores sem pontos ou vírgulas (ex: 100 ou 100.50)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Limpar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Aplicar Filtros'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
