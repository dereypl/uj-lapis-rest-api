lapis = require "lapis"
import respond_to, json_params from require "lapis.application"
import Model from require "lapis.db.model"
db = require "lapis.db"

class Products extends Model
  @primary_key: "id"

class Categories extends Model
  @primary_key: "id"

class extends lapis.Application

  [products: "/products"]: respond_to {
    GET: =>
        products = Products\select!
        return json: { products: products, status: 200 }

    POST: =>
        category_id = @params.category_id
        name = @params.name
        if ( name == nil or name == "" )
          return { json: { error: "Product name cannot be null or empty." }, status: 400 }
        if ( category_id == nil or category_id == "")
          return { json: { error: "Parameter category_id cannot be null or empty." }, status: 400 }
        category = Categories\find category_id
        if ( category == nil )
          return { json: { error: "Category not found." }, status: 404 }

        product = Products\create { name: name, category_id: category_id }
        return { json: product, status: 201 }
  }

  [product_id: "/products/:id"]: respond_to {
     GET: =>
        product = Products\find id: @params.id
        if ( product == nil )
          return { json: { error: "Product not found." }, status: 404 }
        return { json: { product: product }, status: 200 }

     DELETE: =>
        product = Products\find id: @params.id
        if ( product == nil )
          return { json: { error: "Product not found." }, status: 404 }

        product\delete!
        return { json: { success: true }, status: 200 }

     PUT: =>
        category_id = @params.category_id
        name = @params.name

        product = Products\find id: @params.id
        if ( product == nil )
          return { json: { error: "Product not found." }, status: 404 }

        if ( name == nil or name == "" )
          return { json: { error: "Product name cannot be null or empty." }, status: 400 }
        if ( category_id == nil or category_id == "")
          return { json: { error: "Parameter category_id cannot be null or empty." }, status: 400 }

        category = Categories\find category_id
        if ( category == nil )
          return { json: { error: "Category not found." }, status: 404 }

        product.name = name
        product.category_id = category_id
        product\update "name", "category_id"

        return { json: { product: product }, status: 200 }
    }

  [categories: "/categories"]: respond_to {
     GET: =>
        categories = Categories\select!
        return json: { categories: categories, status: 200 }

     POST: =>
        name = @params.name
        if ( name == nil or name == "" )
          return { json: { error: "Category name cannot be null or empty." }, status: 400 }

        category = Categories\create { name: name }
        return { json: category, status: 201 }
    }

  [category_id: "/categories/:id"]: respond_to {
     GET: =>
        category = Categories\find id: @params.id
        if ( category == nil )
          return { json: { error: "Category not found." }, status: 404 }

        return { json: { category: category }, status: 200 }

     DELETE: =>
        category = Categories\find id: @params.id
        if ( category == nil )
          return { json: { error: "Category not found." }, status: 404 }

        category\delete!
        return { json: { success: true }, status: 200 }

     PUT: =>
        name = @params.name
        category = Categories\find id: @params.id
        if ( category == nil )
          return { json: { error: "Category not found." }, status: 404 }

        if ( name == nil or name == "" )
          return { json: { error: "Category name cannot be null or empty." }, status: 400 }

        category.name = name
        category\update "name"

        return { json: { category: category }, status: 200 }
    }
