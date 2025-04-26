'use client'

import Image from 'next/image';
import { useState } from 'react';
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Search, ShoppingCart } from "lucide-react"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { toast } from "@/hooks/use-toast"
import { Toaster } from "@/components/ui/toaster"


interface Vegetable {
  id: number;
  name: string;
  price: number;
  imageUrl: string;
  description: string;
}

const vegetables: Vegetable[] = [
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
];

export default function Home() {
  const [cart, setCart] = useState<{ [id: number]: number }>({});

  const addToCart = (vegetable: Vegetable) => {
    setCart((prevCart) => ({
      ...prevCart,
      [vegetable.id]: (prevCart[vegetable.id] || 0) + 1,
    }));
    toast({
      title: "Added to cart!",
      description: `${vegetable.name} added to your shopping cart.`,
    })
  };

  const removeFromCart = (vegetable: Vegetable) => {
        setCart((prevCart) => {
            const newCart = {...prevCart};
            delete newCart[vegetable.id];
            return newCart;
        });
    };

  const increaseQuantity = (vegetable: Vegetable) => {
    setCart((prevCart) => ({
      ...prevCart,
      [vegetable.id]: (prevCart[vegetable.id] || 0) + 1,
    }));
  };

  const decreaseQuantity = (vegetable: Vegetable) => {
    setCart((prevCart) => {
      if (prevCart[vegetable.id] > 1) {
        return {
          ...prevCart,
          [vegetable.id]: prevCart[vegetable.id] - 1,
        };
      } else {
        const newCart = { ...prevCart };
        delete newCart[vegetable.id];
        return newCart;
      }
    });
  };


  const getTotalItems = () => {
    return Object.values(cart).reduce((acc, quantity) => acc + quantity, 0);
  };

  const getTotalPrice = () => {
    return vegetables.reduce((acc, vegetable) => {
      return acc + (cart[vegetable.id] || 0) * vegetable.price;
    }, 0);
  };

  return (
    <div className="min-h-screen bg-background">
      <Toaster />
      {/* Header */}
      <header className="bg-secondary p-4 flex justify-between items-center">
        <div className="font-bold text-xl">VeggieGo</div>
        <div className="flex items-center space-x-4">
          <Input type="text" placeholder="Search vegetables..." className="max-w-xs rounded-full" />
          <Button variant="outline" size="icon">
            <Search className="h-4 w-4" />
          </Button>
          <Button variant="default" className="relative">
            <ShoppingCart className="h-4 w-4 mr-2" />
            Cart
            {getTotalItems() > 0 && (
              <Badge className="absolute -top-2 -right-2 rounded-full px-2 py-0.5 text-xs">
                {getTotalItems()}
              </Badge>
            )}
          </Button>
        </div>
      </header>

      {/* Main Content */}
      <div className="container mx-auto py-8">
        <h1 className="text-2xl font-bold text-center mb-8">Fresh Vegetables</h1>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {vegetables.map((vegetable) => (
            <Card key={vegetable.id} className="bg-card rounded-lg shadow-md overflow-hidden">
              <Image
                src={vegetable.imageUrl}
                alt={vegetable.name}
                width={200}
                height={150}
                className="w-full h-32 object-cover"
              />
              <CardHeader>
                <CardTitle>{vegetable.name}</CardTitle>
                <CardDescription>{vegetable.description}</CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600">Price: ${vegetable.price.toFixed(2)}</p>
              </CardContent>
              <CardFooter className="flex flex-col space-y-2">
                 {cart[vegetable.id] > 0 ? (
                    <div className="flex items-center justify-between">
                      <Button variant="secondary" size="sm" onClick={() => decreaseQuantity(vegetable)}>
                        -
                      </Button>
                      <span>Quantity: {cart[vegetable.id]}</span>
                      <Button variant="secondary" size="sm" onClick={() => increaseQuantity(vegetable)}>
                        +
                      </Button>
                    </div>
                  ) : (
                    <Button className="w-full" onClick={() => addToCart(vegetable)}>
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
