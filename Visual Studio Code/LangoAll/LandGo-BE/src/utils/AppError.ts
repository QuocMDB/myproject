export class AppError extends Error {
  public readonly status: number;
  public readonly code?: string;

  constructor(message: string, status: number, code?: string) {
    super(message);
    this.status = status;
    this.code = code;
    this.name   = 'AppError';
    Error.captureStackTrace(this, this.constructor);
  }
}