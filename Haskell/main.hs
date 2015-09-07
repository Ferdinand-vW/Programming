import Control.Applicative

data Tree a = Leaf | Node a (Tree a) (Tree a) deriving(Show)

tree = Node 0
			(Node 1
				(Node 2
					Leaf
					Leaf)
				Leaf)
			(Node 3
				Leaf
				Leaf)
				
tree2 = Node 0 Leaf Leaf
				
instance Functor Tree where
	fmap f Leaf = Leaf
	fmap f (Node a b1 b2) = Node (f a) (fmap f b1) (fmap f b2)
	
instance Applicative Tree where
	pure a = Node a Leaf Leaf
	(Node f _ _) <*> tr = fmap f tr
	
instance Monad Tree where
	return a = Node a Leaf Leaf
	Leaf >>= f = Leaf
	Node a Leaf Leaf >>= f = f a
	(Node a l r) >>= f = f a >>= \x -> Node x (l >>= f) (r >>= f)

main :: IO ()
main = print $ maxOfTree $ tree >>= addThree >>= addThree

maxOfTree :: Ord a => Tree a -> Tree a
maxOfTree (Node a Leaf Leaf) = Node a Leaf Leaf
maxOfTree (Node a Leaf r) = maxOfTree r >>= \x -> Node (max a x) Leaf Leaf
maxOfTree (Node a l Leaf) = maxOfTree l >>= \x -> Node (max a x) Leaf Leaf
maxOfTree (Node a l r) = do
	lv <- maxOfTree l
	rv <- maxOfTree r
	Node (maximum [a,lv,rv]) Leaf Leaf

addThree :: Int -> Tree Int
addThree x = return (x + 3)