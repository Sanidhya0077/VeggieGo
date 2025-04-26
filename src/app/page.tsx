'use client'

import Image from 'next/image';
import { useState, useEffect } from 'react';
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Search, ShoppingCart } from "lucide-react"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { toast } from "@/hooks/use-toast"
import { Toaster } from "@/components/ui/toaster"
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription, SheetTrigger } from "@/components/ui/sheet"
import { Trigger } from "@radix-ui/react-dialog";


interface Product {
  id: number;
  name: string;
  price: number;
  imageUrl: string;
  description: string;
}

const products: Product[] = [
  {
    id: 1,
    name: 'Tomato',
    price: 2.50,
    imageUrl: 'https://picsum.photos/200/150',
    description: 'A juicy and red tomato, perfect for salads and sauces.',
  },
  {
    id: 2,
    name: 'Cucumber',
    price: 1.75,
    imageUrl: 'https://picsum.photos/200/151',
    description: 'A crisp and refreshing cucumber, great for hydration.',
  },
  {
    id: 3,
    name: 'Spinach',
    price: 3.00,
    imageUrl: 'https://picsum.photos/200/152',
    description: 'Nutrient-rich spinach, ideal for smoothies and stir-fries.',
  },
  {
    id: 4,
    name: 'Carrot',
    price: 1.25,
    imageUrl: 'https://picsum.photos/200/153',
    description: 'Crunchy and sweet carrot, a healthy snack option.',
  },
  {
    id: 5,
    name: 'Bell Pepper',
    price: 2.00,
    imageUrl: 'https://picsum.photos/200/154',
    description: 'Colorful bell pepper, perfect for adding flavor to any dish.',
  },
  {
    id: 6,
    name: 'Broccoli',
    price: 3.50,
    imageUrl: 'https://picsum.photos/200/155',
    description: 'Healthy broccoli, great for steaming and roasting.',
  },
    {
    id: 7,
    name: 'Apple',
    price: 1.00,
    imageUrl: 'https://picsum.photos/200/156',
    description: 'A crisp and sweet apple, perfect for a quick snack.',
  },
  {
    id: 8,
    name: 'Banana',
    price: 0.75,
    imageUrl: 'https://picsum.photos/200/157',
    description: 'A creamy and convenient banana, great for potassium.',
  },
  {
    id: 9,
    name: 'Orange',
    price: 1.25,
    imageUrl: 'https://picsum.photos/200/158',
    description: 'A juicy and citrusy orange, rich in Vitamin C.',
  },
  {
    id: 10,
    name: 'Grapes',
    price: 2.00,
    imageUrl: 'https://picsum.photos/200/159',
    description: 'Sweet and refreshing grapes, perfect for snacking.',
  },
  {
    id: 11,
    name: 'Strawberry',
    price: 3.00,
    imageUrl: 'https://picsum.photos/200/160',
    description: 'Delicious and vibrant strawberries, great for desserts.',
  },
  {
    id: 12,
    name: 'Blueberry',
    price: 4.00,
    imageUrl: 'https://picsum.photos/200/161',
    description: 'Antioxidant-rich blueberries, ideal for smoothies and cereals.',
  },
];

export default function Home() {
  const [cart, setCart] = useState<{ [id: number]: number }>({});
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredProducts, setFilteredProducts] = useState<Product[]>(products);

  useEffect(() => {
    const results = products.filter(product =>
      product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
    setFilteredProducts(results);
  }, [searchTerm]);

  const addToCart = (product: Product) => {
    setCart((prevCart) => {
      const newCart = {
        ...prevCart,
        [product.id]: (prevCart[product.id] || 0) + 1,
      };
      toast({
        title: "Added to cart!",
        description: `${product.name} added to your shopping cart.`,
      });
      return newCart;
    });
  };


  const removeFromCart = (product: Product) => {
        setCart((prevCart) => {
            const newCart = {...prevCart};
            delete newCart[product.id];
            return newCart;
        });
    };

  const increaseQuantity = (product: Product) => {
    setCart((prevCart) => ({
      ...prevCart,
      [product.id]: (prevCart[product.id] || 0) + 1,
    }));
  };

  const decreaseQuantity = (product: Product) => {
    setCart((prevCart) => {
      if (prevCart[product.id] > 1) {
        return {
          ...prevCart,
          [product.id]: prevCart[product.id] - 1,
        };
      } else {
        const newCart = { ...prevCart };
        delete newCart[product.id];
        return newCart;
      }
    });
  };


  const getTotalItems = () => {
    return Object.values(cart).reduce((acc, quantity) => acc + quantity, 0);
  };

  const getTotalPrice = () => {
    return products.reduce((acc, product) => {
      return acc + (cart[product.id] || 0) * product.price;
    }, 0);
  };

    const cartItems = products.filter(product => cart[product.id] > 0);


  return (
    <div className="min-h-screen bg-background">
      <Toaster />
      {/* Header */}
      <header className="bg-secondary p-4 flex justify-between items-center">
        <div className="font-bold text-xl">VeggieGo</div>
        <div className="flex items-center space-x-4">
          <Input
            type="text"
            placeholder="Search fruits and vegetables..."
            className="max-w-xs rounded-full"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <Button variant="ghost" size="icon" className="bg-transparent">
            <Search className="h-4 w-4" />
          </Button>
          <Sheet>
              <SheetTrigger asChild>
                  <Button variant="default" className="relative">
                      <ShoppingCart className="h-4 w-4 mr-2" />
                      Cart
                      {getTotalItems() > 0 && (
                          <Badge className="absolute -top-2 -right-2 rounded-full px-2 py-0.5 text-xs">
                              {getTotalItems()}
                          </Badge>
                      )}
                  </Button>
              </SheetTrigger>
              <SheetContent>
                  <SheetHeader>
                      <SheetTitle>Shopping Cart</SheetTitle>
                      <SheetDescription>
                          Review and manage your cart items.
                      </SheetDescription>
                  </SheetHeader>
                  <div className="mt-4">
                        {cartItems.length === 0 ? (
                            <p>Your cart is empty.</p>
                        ) : (
                            <ul>
                                {cartItems.map((product) => (
                                    <li key={product.id} className="flex items-center justify-between py-2">
                                        <div className="flex items-center space-x-2">
                                            <Image
                                                src={product.imageUrl}
                                                alt={product.name}
                                                width={50}
                                                height={50}
                                                className="rounded-md"
                                            />
                                            <div>
                                                <p className="font-medium">{product.name}</p>
                                                <p className="text-sm text-gray-500">
                                                    ${product.price.toFixed(2)} x {cart[product.id]}
                                                </p>
                                            </div>
                                        </div>
                                        <div>
                                            <Button variant="secondary" size="sm" onClick={() => decreaseQuantity(product)}>
                                                -
                                            </Button>
                                            <span className="mx-2">{cart[product.id]}</span>
                                            <Button variant="secondary" size="sm" onClick={() => increaseQuantity(product)}>
                                                +
                                            </Button>
                                        </div>
                                    </li>
                                ))}
                            </ul>
                        )}
                    </div>
                    <div className="mt-4">
                        <div className="flex justify-between font-medium">
                            <span>Total:</span>
                            <span>${getTotalPrice().toFixed(2)}</span>
                        </div>
                        <Button className="w-full mt-4">
                            Checkout
                        </Button>
                    </div>
              </SheetContent>
          </Sheet>
        </div>
      </header>

      {/* Main Content */}
      <div className="container mx-auto py-8">
        <h1 className="text-2xl font-bold text-center mb-8">Fresh Fruits and Vegetables</h1>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {filteredProducts.map((product) => (
            <Card key={product.id} className="bg-card rounded-lg shadow-md overflow-hidden">
              <Image
                src={product.imageUrl}
                alt={product.name}
                width={200}
                height={150}
                className="w-full h-32 object-cover"
              />
              <CardHeader>
                <CardTitle>{product.name}</CardTitle>
                <CardDescription>{product.description}</CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600">Price: ${product.price.toFixed(2)}</p>
              </CardContent>
              <CardFooter className="flex flex-col space-y-2">
                 {cart[product.id] > 0 ? (
                    <div className="flex items-center justify-between">
                      <Button variant="secondary" size="sm" onClick={() => decreaseQuantity(product)}>
                        -
                      </Button>
                      <span>Quantity: {cart[product.id]}</span>
                      <Button variant="secondary" size="sm" onClick={() => increaseQuantity(product)}>
                        +
                      </Button>
                    </div>
                  ) : (
                    <Button className="w-full" onClick={() => addToCart(product)}>
                      Add to Cart
                    </Button>
                  )}
              </CardFooter>
            </Card>
          ))}
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-secondary p-4 text-center">
        <p>
          © {new Date().getFullYear()} VeggieGo. All rights reserved.
        </p>
      </footer>
    </div>
  );
}


