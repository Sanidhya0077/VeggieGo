'use client'

import Image from 'next/image';
import { useState } from 'react';
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Search, Plus } from "lucide-react"

interface Vegetable {
  id: number;
  name: string;
  price: number;
  imageUrl: string;
}

const vegetables: Vegetable[] = [
  {
    id: 1,
    name: 'Tomato',
    price: 2.50,
    imageUrl: 'https://picsum.photos/200/150',
  },
  {
    id: 2,
    name: 'Cucumber',
    price: 1.75,
    imageUrl: 'https://picsum.photos/200/151',
  },
  {
    id: 3,
    name: 'Spinach',
    price: 3.00,
    imageUrl: 'https://picsum.photos/200/152',
  },
  {
    id: 4,
    name: 'Carrot',
    price: 1.25,
    imageUrl: 'https://picsum.photos/200/153',
  },
  {
    id: 5,
    name: 'Bell Pepper',
    price: 2.00,
    imageUrl: 'https://picsum.photos/200/154',
  },
  {
    id: 6,
    name: 'Broccoli',
    price: 3.50,
    imageUrl: 'https://picsum.photos/200/155',
  },
];

export default function Home() {
  const [cart, setCart] = useState<{ [id: number]: number }>({});

  const addToCart = (vegetable: Vegetable) => {
    setCart((prevCart) => ({
      ...prevCart,
      [vegetable.id]: (prevCart[vegetable.id] || 0) + 1,
    }));
  };

  return (
    <div className="container mx-auto py-8">
      {/* Search Bar */}
      <div className="flex items-center justify-center mb-8">
        <div className="relative w-1/2">
          <Input type="text" placeholder="Search for vegetables..." className="rounded-full pl-5 pr-12" />
          <Button variant="ghost" size="icon" className="absolute right-2 top-1/2 -translate-y-1/2">
            <Search className="h-4 w-4" />
          </Button>
        </div>
      </div>

      <h1 className="text-2xl font-bold text-center mb-4">Fresh Vegetables</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {vegetables.map((vegetable) => (
          <div key={vegetable.id} className="bg-card rounded-lg shadow-md overflow-hidden">
            <Image
              src={vegetable.imageUrl}
              alt={vegetable.name}
              width={200}
              height={150}
              className="w-full h-32 object-cover"
            />
            <div className="p-4">
              <h2 className="text-lg font-semibold text-gray-800">{vegetable.name}</h2>
              <p className="mt-2 text-gray-600">Price: ${vegetable.price.toFixed(2)}</p>
              <Button
                className="mt-4 w-full flex items-center justify-center"
                onClick={() => addToCart(vegetable)}
              >
                Add to Cart
                {cart[vegetable.id] > 0 && <Plus className="ml-2 h-4 w-4" />}
              </Button>
             {cart[vegetable.id] > 0 && (
                <p className="mt-2 text-green-600">Quantity: {cart[vegetable.id]}</p>
              )}
              {cart[vegetable.id] > 0 && (
                  <Button
                      variant="secondary"
                      size="sm"
                      className="mt-2 w-full"
                      onClick={() => setCart(prevCart => ({
                        ...prevCart,
                        [vegetable.id]: (prevCart[vegetable.id] || 1) + 1,
                      }))}
                  >
                    + Add to Quantity
                  </Button>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
