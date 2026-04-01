import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product_model.dart';
import '../providers/favorites_provider.dart';

class ProductFormPage extends StatefulWidget {
  // Se receber um produto = modo edição
  // Se não receber nada (null) = modo criação
  final ProductModel? product;

  const ProductFormPage({super.key, this.product});

  bool get isEditing => product != null;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;
  late TextEditingController _categoryController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Se for edição, pré-preenche os campos com os dados do produto
    // Se for criação, inicializa vazio
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _imageController = TextEditingController(text: widget.product?.image ?? '');
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final provider = context.read<FavoritesProvider>();

      final product = ProductModel(
        id: widget.product?.id ?? 0,
        title: _titleController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        image: _imageController.text,
        category: _categoryController.text,
        ratingRate: widget.product?.ratingRate ?? 0.0,
        ratingCount: widget.product?.ratingCount ?? 0,
      );

      if (widget.isEditing) {
        await provider.updateProduct(product);
      } else {
        await provider.createProduct(product);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Produto atualizado: ${product.title}'
                : 'Produto cadastrado: ${product.title}',
          ),
          backgroundColor: Colors.black87,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Erro ao atualizar produto: $e'
                : 'Erro ao cadastrar produto: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar Produto' : 'Novo Produto',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),

              // Título
              _buildField(
                controller: _titleController,
                label: 'Título',
                icon: Icons.title_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Preço
              _buildField(
                controller: _priceController,
                label: 'Preço',
                icon: Icons.attach_money_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o preço';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Informe um valor numérico válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Descrição
              _buildField(
                controller: _descriptionController,
                label: 'Descrição',
                icon: Icons.description_rounded,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // URL da imagem
              _buildField(
                controller: _imageController,
                label: 'URL da imagem',
                icon: Icons.image_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a URL da imagem';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Categoria
              _buildField(
                controller: _categoryController,
                label: 'Categoria',
                icon: Icons.category_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a categoria';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.isEditing ? 'Atualizar' : 'Salvar',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
