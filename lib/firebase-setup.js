// This is a sample script to initialize your Firebase Firestore database with ingredient data
// You would run this once to set up your database

const admin = require('firebase-admin');
const serviceAccount = require('./service-account-key.json'); // Your Firebase service account key

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Meat ingredients data
const meats = [
  {
    name: 'Chicken Breast',
    calories: 165,
    price: 3.99,
    imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Beef Steak',
    calories: 271,
    price: 7.99,
    imageUrl: 'https://images.unsplash.com/photo-1594041680523-cde9e8935483?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Salmon',
    calories: 208,
    price: 9.99,
    imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Turkey',
    calories: 189,
    price: 4.99,
    imageUrl: 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Pork Chop',
    calories: 231,
    price: 5.99,
    imageUrl: 'https://images.unsplash.com/photo-1504649346668-34072c29f3a1?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Shrimp',
    calories: 85,
    price: 8.99,
    imageUrl: 'https://images.unsplash.com/photo-1565680018142-ad66679c0ed7?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  }
];

// Vegetable ingredients data
const vegetables = [
  {
    name: 'Broccoli',
    calories: 55,
    price: 1.99,
    imageUrl: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Spinach',
    calories: 23,
    price: 2.49,
    imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Carrots',
    calories: 41,
    price: 1.29,
    imageUrl: 'https://images.unsplash.com/photo-1582515073490-39981397c445?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Bell Peppers',
    calories: 30,
    price: 1.79,
    imageUrl: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Tomatoes',
    calories: 18,
    price: 1.49,
    imageUrl: 'https://images.unsplash.com/photo-1518977822534-7049a61ee0c2?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Zucchini',
    calories: 17,
    price: 1.69,
    imageUrl: 'https://images.unsplash.com/photo-1587156816999-d6be593eee1c?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  }
];

// Carb ingredients data
const carbs = [
  {
    name: 'Brown Rice',
    calories: 216,
    price: 2.49,
    imageUrl: 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Quinoa',
    calories: 222,
    price: 3.99,
    imageUrl: 'https://images.unsplash.com/photo-1598265023580-ccb537f3ce86?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Sweet Potato',
    calories: 114,
    price: 1.99,
    imageUrl: 'https://images.unsplash.com/photo-1596097558062-8a12b9b14c49?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Whole Wheat Pasta',
    calories: 174,
    price: 2.79,
    imageUrl: 'https://images.unsplash.com/photo-1551462147-ff29053bfc14?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Oats',
    calories: 389,
    price: 2.29,
    imageUrl: 'https://images.unsplash.com/photo-1539741904453-ee927ba72d0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  },
  {
    name: 'Black Beans',
    calories: 227,
    price: 1.89,
    imageUrl: 'https://images.unsplash.com/photo-1580914190913-1f5ef95e46fb?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80'
  }
];

// Function to add data to Firestore
async function addIngredientsToFirestore() {
  try {
    // Add meat ingredients
    const meatBatch = db.batch();
    const meatRef = db.collection('meats');
    
    meats.forEach(meat => {
      const docRef = meatRef.doc();
      meatBatch.set(docRef, meat);
    });
    
    await meatBatch.commit();
    console.log('Added meat ingredients to Firestore');
    
    // Add vegetable ingredients
    const vegBatch = db.batch();
    const vegRef = db.collection('vegetables');
    
    vegetables.forEach(veg => {
      const docRef = vegRef.doc();
      vegBatch.set(docRef, veg);
    });
    
    await vegBatch.commit();
    console.log('Added vegetable ingredients to Firestore');
    
    // Add carb ingredients
    const carbBatch = db.batch();
    const carbRef = db.collection('carbs');
    
    carbs.forEach(carb => {
      const docRef = carbRef.doc();
      carbBatch.set(docRef, carb);
    });
    
    await carbBatch.commit();
    console.log('Added carb ingredients to Firestore');
    
    console.log('All ingredients have been added to Firestore');
  } catch (error) {
    console.error('Error adding ingredients to Firestore:', error);
  }
}

// Run the function
addIngredientsToFirestore()
  .then(() => {
    console.log('Setup complete!');
    process.exit(0);
  })
  .catch(error => {
    console.error('Setup failed:', error);
    process.exit(1);
  });
