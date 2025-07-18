USE [master]
GO
/****** Object:  Database [PRJ301_SP25_PlanMenu]    Script Date: 7/10/2024 2:06:53 AM ******/
CREATE DATABASE [PRJ301_SP25_PlanMenu]
GO

USE [PRJ301_SP25_PlanMenu]
GO

ALTER DATABASE [PRJ301_SP25_PlanMenu] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PRJ301_SP25_PlanMenu].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET ARITHABORT OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET RECOVERY FULL 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET  MULTI_USER 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'PRJ301_SP25_PlanMenu', N'ON'
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET QUERY_STORE = ON
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PRJ301_SP25_PlanMenu]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 7/10/2024 2:06:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [varchar](50) NOT NULL,
	[description] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 7/10/2024 2:06:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[orderID] [int] NOT NULL,
	[product_id] [int] NULL,
	[quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 7/10/2024 2:06:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[orderID] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[date] [varchar](255) NULL,
	[address] [nvarchar](max) NULL,
	[phonenumber] [varchar](255) NULL,
	[totalmoney] [float] NULL,
	[status] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 7/10/2024 2:06:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[product_name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](500) NULL,
	[price] [decimal](10, 2) NOT NULL,
	[category_id] [int] NULL,
	[image_url] [nvarchar](500) NULL,
	[quantity_in_stock] [int] NOT NULL,
	[quantity_sold] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 7/10/2024 2:06:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[product_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[rating] [int] NULL,
	[comment] [nvarchar](255) NULL,
	[review_date] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/10/2024 2:06:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](255) NOT NULL,
	[email] [varchar](255) NOT NULL,
	[full_name] [varchar](100) NULL,
	[phone_number] [varchar](20) NULL,
	[isAdmin] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (1, N'Main dishes', N'Các món chính thường là phần chính của bữa ăn')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (2, N'Side dishes', N'Các món phụ đi kèm với món chính để bổ sung hương vị')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (3, N'Desserts', N'Các món tráng miệng thường được dùng sau bữa ăn chính')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (4, N'Beverages', N'Các loại đồ uống giải khát, cà phê, nước ép')
INSERT [dbo].[Categories] ([category_id], [category_name], [description]) VALUES (5, N'Appetizers', N'Các món khai vị được dùng để kích thích vị giác trước bữa ăn chính')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (1, N'Hamburger', N'Delicious beef patty with lettuce and tomato', CAST(8.99 AS Decimal(10, 2)), 1, N'https://vinpro.store/wp-content/uploads/2022/07/cach-lam-banh-Hamburger-5.jpg', 50, 20)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (2, N'Caesar Salad', N'Fresh romaine lettuce with Caesar dressing', CAST(6.49 AS Decimal(10, 2)), 2, N'https://www.thespruceeats.com/thmb/DRaBINVopeoHOpjJn66Yh7pMBSc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/classic-caesar-salad-recipe-996054-Hero_01-33c94cc8b8e841ee8f2a815816a0af95.jpg', 30, 15)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (3, N'Chocolate Cake', N'Rich chocolate cake with frosting', CAST(12.99 AS Decimal(10, 2)), 3, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFASb_66xiP3Gc4Ucdun-wI5CwzOhSIxWS8g&s', 20, 10)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (4, N'Iced Coffee', N'Chilled coffee with cream and sugar', CAST(3.99 AS Decimal(10, 2)), 4, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqLs454hVyYfUYn9l3LVmP8T_0-0Kjf3AODw&s', 40, 30)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (5, N'Spring Rolls', N'Fresh vegetable spring rolls with dipping sauce', CAST(5.99 AS Decimal(10, 2)), 5, N'https://www.thespruceeats.com/thmb/LAD6HCmf0MFSpV3JDJgM9n7REos=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/SES-thai-fresh-rolls-with-vegetarian-option-3217706-hero-A-3bdb04a8ee2444a2ab6873810a334642.jpg', 25, 12)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (6, N'Pizza', N'Classic pepperoni pizza with cheese', CAST(10.99 AS Decimal(10, 2)), 1, N'https://thucphamsieuthi.vn/wp-content/uploads/2021/08/banh-pizza-hai-san-dong-lanh.jpg', 60, 25)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (7, N'Chicken Wings', N'Spicy buffalo chicken wings', CAST(7.99 AS Decimal(10, 2)), 2, N'https://www.allrecipes.com/thmb/AtViolcfVtInHgq_mRtv4tPZASQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/ALR-187822-baked-chicken-wings-4x3-5c7b4624c8554f3da5aabb7d3a91a209.jpg', 45, 18)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (8, N'Cheesecake', N'Creamy cheesecake with strawberry topping', CAST(9.99 AS Decimal(10, 2)), 3, N'https://www.onceuponachef.com/images/2017/12/cheesecake-1200x1393.jpg', 15, 8)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (9, N'Smoothie', N'Mixed fruit smoothie with yogurt', CAST(4.99 AS Decimal(10, 2)), 4, N'https://www.eatingwell.com/thmb/KCDDSEVOd4pRYoDokPJ4cUuwLxI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/EWL-57793-berry-kefir-smoothie-Hero-01-A-ae9e20c50f1843928b81c102bfa80b4c.jpg', 35, 28)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (10, N'Sushi Roll', N'Assorted sushi rolls with soy sauce', CAST(11.49 AS Decimal(10, 2)), 5, N'https://www.allrecipes.com/thmb/XT7-9MROYJZvNyQR4J40HGOVDmQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/19511smoked-salmon-sushi-rollfabeveryday4x3-159a22b4d3ac49fe9a146db94b53c930.jpg', 30, 15)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (11, N'Steak', N'Juicy grilled steak with mashed potatoes', CAST(15.99 AS Decimal(10, 2)), 1, N'https://cdn.tgdd.vn/2020/11/CookProduct/1-1200x676-22.jpg', 25, 10)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (12, N'French Fries', N'Crispy golden french fries', CAST(3.49 AS Decimal(10, 2)), 2, N'https://images.themodernproper.com/billowy-turkey/production/posts/2022/Homemade-French-Fries_8.jpg?w=1200&q=82&auto=format&fit=crop&dm=1662474181&s=577d686ad285c29c256e35d3ce9e437b', 50, 22)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (13, N'Tiramisu', N'Classic Italian tiramisu dessert', CAST(8.49 AS Decimal(10, 2)), 3, N'https://cdn.tgdd.vn/Files/2021/08/08/1373908/tiramisu-la-gi-y-nghia-cua-banh-tiramisu-202108082258460504.jpg', 20, 12)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (14, N'Milkshake', N'Chocolate milkshake with whipped cream', CAST(5.49 AS Decimal(10, 2)), 4, N'https://assets.epicurious.com/photos/647df8cad9749492c4d5d407/4:3/w_4886,h_3664,c_limit/StrawberryMilkshake_RECIPE_053123_3599.jpg', 40, 32)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (15, N'Taco', N'Mexican taco with beef and salsa', CAST(6.99 AS Decimal(10, 2)), 5, N'https://www.thespruceeats.com/thmb/ereeBcFkDEbDT2VSlDe34sqXO_8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/chicken-tinga-tinga-de-pollo-4773239-Hero_01-1bd1d960c02a4fdb812323b8c60fd55b.jpg', 30, 18)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (16, N'Pasta', N'Homemade pasta with marinara sauce', CAST(9.99 AS Decimal(10, 2)), 1, N'https://www.allrecipes.com/thmb/QiGptPjQB5mqSXGVxE4sLPMJs_4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/AR-269500-creamy-garlic-pasta-Beauties-2x1-bcd9cb83138849e4b17104a1cd51d063.jpg', 40, 20)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (17, N'Onion Rings', N'Crispy battered onion rings', CAST(4.99 AS Decimal(10, 2)), 2, N'https://static01.nyt.com/images/2020/04/22/dining/ejm-sourdough-03/ejm-sourdough-03-superJumbo.jpg', 35, 15)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (18, N'Key Lime Pie', N'Refreshing key lime pie', CAST(7.99 AS Decimal(10, 2)), 3, N'https://www.allrecipes.com/thmb/1aP8lFhJJXky1qjk5fbMTzVAjtU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/12698-Easy-Key-Lime-Pie-ddmfs-103444-4x3-1-eb1a59500e384b2b8939094ce18d08be.jpg', 25, 10)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (19, N'Espresso', N'Strong espresso shot', CAST(2.99 AS Decimal(10, 2)), 4, N'https://www.kitchenaid.com/is/image/content/dam/business-unit/kitchenaid/en-us/marketing-content/site-assets/page-content/blog/difference-between-espresso-and-coffee/espresso-vs-coffee-img0M.jpg?fmt=png-alpha&qlt=85,0&resMode=sharp2&op_usm=1.75,0.3,2,0&scl=1&constrain=fit,1', 50, 40)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (20, N'Burrito', N'Spicy burrito with beans and cheese', CAST(8.99 AS Decimal(10, 2)), 5, N'https://cdn.britannica.com/13/234013-050-73781543/rice-and-chorizo-burrito.jpg', 30, 25)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (21, N'Roast Chicken', N'Roast chicken with herbs and vegetables', CAST(12.99 AS Decimal(10, 2)), 1, N'https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2022/10/Roast-Chicken-main.jpg', 20, 12)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (22, N'Nachos', N'Loaded nachos with cheese and jalapenos', CAST(6.49 AS Decimal(10, 2)), 2, N'https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2022/03/Nachos-main-1.jpg', 45, 30)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (23, N'Panna Cotta', N'Italian dessert with caramel sauce', CAST(7.49 AS Decimal(10, 2)), 3, N'https://moderncook.com.vn/recipes/wp-content/uploads/2019/10/MG_7004-Large-1024x682.jpeg', 30, 18)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (24, N'Hot Chocolate', N'Rich hot chocolate with marshmallows', CAST(3.99 AS Decimal(10, 2)), 4, N'https://assets.bonappetit.com/photos/57accdd1f1c801a1038bc794/1:1/w_2560%2Cc_limit/Hot-Chocolate-2-of-5.jpg', 40, 25)
INSERT [dbo].[Products] ([product_id], [product_name], [description], [price], [category_id], [image_url], [quantity_in_stock], [quantity_sold]) VALUES (25, N'Gyro', N'Greek gyro with tzatziki sauce', CAST(9.49 AS Decimal(10, 2)), 5, N'https://www.mygreekdish.com/wp-content/uploads/2023/05/Beef-Gyro-souvlaki.jpeg', 25, 15)
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (1, N'nguyenvana', N'0000', N'nguyenvana@gmail.com', N'Nguyen Van A', N'0987654321', 1)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (2, N'nguyenvanb', N'0000', N'nguyenvanb@gmail.com', N'Nguyen Van B', N'0987654322', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (3, N'nguyenvanc', N'0000', N'nguyenvanc@gmail.com', N'Nguyen Van C', N'0987654323', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (4, N'nguyenvand', N'123456', N'nguyenvand@gmail.com', N'Nguyen Van D', N'0987654324', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (5, N'nguyenvane', N'123456', N'nguyenvane@gmail.com', N'Nguyen Van E', N'0987654325', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (6, N'nguyenvanf', N'123456', N'nguyenvanf@gmail.com', N'Nguyen Van F', N'0987654326', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (7, N'nguyenvang', N'123456', N'nguyenvang@gmail.com', N'Nguyen Van G', N'0987654327', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (8, N'nguyenvanh', N'123456', N'nguyenvanh@gmail.com', N'Nguyen Van H', N'0987654328', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (12, N'nguyenvant', N'123456', N'nguyenvant@gmail.com', N'Nguyen Van T', N'0987654342', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (13, N'nguyenvanu', N'123456', N'nguyenvanu@gmail.com', N'Nguyen Van U', N'0987654343', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (16, N'nguyenvanx', N'123456', N'nguyenvanx@gmail.com', N'Nguyen Van X', N'0987654346', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (17, N'nguyenvany', N'123456', N'nguyenvany@gmail.com', N'Nguyen Van Y', N'0987654347', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (18, N'nguyenvanz', N'123456', N'nguyenvanz@gmail.com', N'Nguyen Van Z', N'0987654348', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (22, N'MingQuang', N'0000', N'minhnqhe176167@fpt.edu.vn', N'Nguyen Quang Minh', N'0943081570', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (24, N'min', N'0000', N'minhnqhe176167@fpt.edu.vn', N'Nguyen Quang Minh', N'0943081570', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (27, N'linh', N'0000', N'linhntdHE172208@fpt.edu.vn', N'Nguyen Thi Dieu Linh', N'0378468362', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (28, N'Mings', N'0000', N'minhnqhe176167@fpt.edu.vn', N'Nguyen Quang Minh', N'0943081570', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (29, N'nguyenvani', N'123456', N'nguyenvani@gmail.com', N'Nguyen Van I', N'0987654329', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (30, N'nguyenvanj', N'123456', N'nguyenvanj@gmail.com', N'Nguyen Van J', N'0987654330', 0)
INSERT [dbo].[Users] ([user_id], [username], [password], [email], [full_name], [phone_number], [isAdmin]) VALUES (31, N'nguyenvanw', N'123456', N'nguyenvanw@gmail.com', N'Nguyen Van W', N'0987654345', 0)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD FOREIGN KEY([orderID])
REFERENCES [dbo].[Orders] ([orderID])
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[Products] ([product_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories] ([category_id])
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[Products] ([product_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
ON DELETE CASCADE
GO
USE [master]
GO
ALTER DATABASE [PRJ301_SP25_PlanMenu] SET  READ_WRITE 
GO

