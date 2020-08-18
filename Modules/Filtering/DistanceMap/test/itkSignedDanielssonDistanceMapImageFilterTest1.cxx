/*=========================================================================
 *
 *  Copyright NumFOCUS
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0.txt
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *=========================================================================*/
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"

#include "itkSignedDanielssonDistanceMapImageFilter.h"

// Convenience function to template over dimension and avoid code duplication.
template <unsigned int ImageDimension>
int
itkSignedDanielssonDistanceMapImageFilterTest1(char * argv[])
{
  using InputPixelType = unsigned char;
  using OutputPixelType = float;

  using InputImageType = itk::Image<InputPixelType, ImageDimension>;
  using OutputImageType = itk::Image<OutputPixelType, ImageDimension>;
  using ReaderType = itk::ImageFileReader<InputImageType>;
  using WriterType = itk::ImageFileWriter<OutputImageType>;

  typename ReaderType::Pointer reader = ReaderType::New();
  reader->SetFileName(argv[1]);
  reader->Update();

  using FilterType = itk::SignedDanielssonDistanceMapImageFilter<InputImageType, OutputImageType>;

  typename FilterType::Pointer filter = FilterType::New();
  filter->SetInput(reader->GetOutput());
  filter->SetSquaredDistance(false);
  filter->SetUseImageSpacing(true);
  filter->SetInsideIsPositive(false);
  filter->Update();
  filter->Print(std::cout);

  typename WriterType::Pointer writer = WriterType::New();
  writer->SetInput(filter->GetOutput());
  writer->SetFileName(argv[2]);
  writer->UseCompressionOn();
  writer->Update();

  return EXIT_SUCCESS;
}

int
itkSignedDanielssonDistanceMapImageFilterTest1(int argc, char * argv[])
{
  if (argc < 3)
  {
    std::cerr << "Usage: " << argv[0] << " InputImage OutputImage [ImageDimension]\n";
    return EXIT_FAILURE;
  }

  // Default value for ImageDimension
  int ImageDimension = 3;
  if (argc == 4)
  {
    ImageDimension = std::stoi(argv[3]);
  }

  int result;
  if (ImageDimension == 2)
  {
    result = itkSignedDanielssonDistanceMapImageFilterTest1<2>(argv);
  }
  else if (ImageDimension == 3)
  {
    result = itkSignedDanielssonDistanceMapImageFilterTest1<3>(argv);
  }
  else if (ImageDimension == 4)
  {
    result = itkSignedDanielssonDistanceMapImageFilterTest1<4>(argv);
  }
  else
  {
    result = EXIT_FAILURE;
  }

  return result;
}
