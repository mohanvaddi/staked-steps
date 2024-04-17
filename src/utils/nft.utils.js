import Jimp from 'jimp';
import fs from 'fs';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export const createNftImage = async(userImageBuffer, text1, text2) => {
  try {
    const backgroundColor = "#b2dbb7";

    const logoImage = await Jimp.read(`${__dirname}/logo.png`);
    const userImage = await Jimp.read(userImageBuffer);

    const squareSize = Math.min(userImage.getWidth(), userImage.getHeight());
    const squareImage = await userImage.cover(squareSize, squareSize);

    const padding = squareSize * 0.05;

    const canvasWidth = squareSize + (padding * 2);
    const canvasHeight = squareSize * 5 / 4 + (padding * 2);
    const canvas = new Jimp(canvasWidth, canvasHeight, backgroundColor);

    canvas.composite(squareImage, padding, padding);

    const logoResizeHeight = canvasHeight * 0.1;
    const logoResizeWidth = Jimp.AUTO;
    await logoImage.resize(logoResizeWidth, logoResizeHeight);

    const xPositionForLogo = (canvasWidth - logoImage.getWidth()) / 1.05;
    const yPositionForLogo = canvasHeight - logoImage.getHeight() - padding - 25;

    canvas.composite(logoImage, xPositionForLogo, yPositionForLogo);

    const font = await Jimp.loadFont(Jimp.FONT_SANS_32_BLACK);
    const font2 = await Jimp.loadFont(Jimp.FONT_SANS_16_BLACK);

    const xPositionForText = padding;
    const yPositionForSubheading = squareSize + padding + (canvasHeight * 0.05); 
    const yPositionForBodyText = yPositionForSubheading + 40; 

    canvas.print(font, xPositionForText, yPositionForSubheading, text1, canvasWidth - (padding * 2));
    canvas.print(font2, xPositionForText, yPositionForBodyText, text2, canvasWidth - (padding * 2));

    const outputBuffer = await canvas.getBufferAsync(Jimp.MIME_PNG);
    return outputBuffer;
  } catch (error) {
    console.error('Error creating image:', error);
    throw error;
  }
}