import apiClient from '../config/axios'

export const ProductAPI = {
  async getPaginatedProducts(page: number, limit: number): Promise<ProductResponse> {
    const res = await apiClient.get(`/products`, { params: { page, limit } })
    return res.data
  },
  async getProductById(productId: string): Promise<Product> {
    const res = await apiClient.get(`/products/${productId}`)
    return res.data
  },
  async searchProducts(query: string): Promise<ProductResponse> {
    const res = await apiClient.get(`/products/search`, { params: { q: query } })
    return res.data
  }
}
