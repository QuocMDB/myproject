import cloudinary from "../config/cloudinary";

export const uploadMultipleImages = async (
  files: Express.Multer.File[],
  folder: string,
): Promise<string[]> => {
  const uploadPromises = files.map((file) => {
    return new Promise<string>((resolve, reject) => {
      cloudinary.uploader
        .upload_stream({ folder }, (error, result) => {
          if (error) return reject(error);
          resolve(result!.secure_url);
        })
        .end(file.buffer);
    });
  });

  return Promise.all(uploadPromises);
};
