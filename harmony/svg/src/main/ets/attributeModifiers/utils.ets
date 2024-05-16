import matrix4 from '@ohos.matrix4';
import { SVGViewRawCommon } from '../common/SVGType';
import { getTransform } from '../common/SVGCommon';
interface OffsetType{
  offsetX: number,
  offsetY: number
}

function calculateOffset(parentWidth: number, parentHeight: number, childWidth: number, childHeight: number): OffsetType {
  //子容器的宽高比
  console.log('yzx calculateOffset')
  console.log('yzx parentWidth:${parentWidth}, parentHeight:${parentHeight}, childWidth:${childWidth}, childHeight:${childHeight}');
  const childAspectRatio = childWidth / childHeight;

  //计算子容器在父容器中可放大的最大宽度和高度
  let scaledWidth: number, scaledHeight: number;
  if(parentWidth / parentHeight < childAspectRatio) {
    //宽度是限制因素，按宽度缩放高度
    scaledWidth = parentWidth;
    scaledHeight = parentWidth / childAspectRatio;
  } else {
    //高度是限制因素，按高度缩放宽度
    scaledHeight = parentHeight;
    scaledWidth = parentHeight * childAspectRatio;
  }

  //计算子容器在父容器中居中所需的x,y偏移量
  const offsetX = (parentWidth - scaledWidth) / 2;
  const offsetY = (parentHeight - scaledHeight) / 2;
  console.log('yzx scaledWidth:${scaledWidth}, scaledHeight:${scaledHeight}, offsetX:${offsetX}, offsetY:${offsetY}')
  //返回偏移量对象
  return{
    offsetX: offsetX,
    offsetY: offsetY,
  };
}

export interface translateType {
  x: number,
  y: number
}

export function calGroupBoxOffset(svgViewCommon: SVGViewRawCommon): translateType {
  let res: translateType = {
    x: 0,
    y: 0
  }

  if (svgViewCommon) {
    let transX = 0
    let transY = 0
    let ignore = false
    if (svgViewCommon.groupBox.minX !== 0 || svgViewCommon.groupBox.minY !== 0) {
      console.log(`yzx 有不为0`)
      transX = -(svgViewCommon.groupBox.minX || 0)
      transY = -(svgViewCommon.groupBox.minY || 0)
    } else {
      ignore = true
      console.log(`yzx 都为0`)
      transX = (svgViewCommon.svgWidth - svgViewCommon.groupBox.width) / 2 / svgViewCommon.scaleValue
      transY = (svgViewCommon.svgHeight - svgViewCommon.groupBox.height) / 2 / svgViewCommon.scaleValue
    }
    console.log(`yzx group 之后 transX: ${transX}`)
    console.log(`yzx group 之后 transY: ${transY}`)

    const groupBox = svgViewCommon.groupBox
    const svgWidth = svgViewCommon.svgWidth
    const svgHeight = svgViewCommon.svgHeight

    if ((svgWidth / svgHeight) != (groupBox.width / groupBox.height) && !ignore) {
      const offset: OffsetType = calculateOffset(svgWidth, svgHeight, groupBox.width, groupBox.height)
      res = {
        x: offset.offsetX / svgViewCommon.scaleValue,
        y: offset.offsetY / svgViewCommon.scaleValue,
      }
      console.log(`yzx 之后 offset: ${JSON.stringify(res)}`)
    } else {
      console.log('宽高一致')
    }
    res.x += transX
    res.y += transY
  }
  console.log(`yzx calGroupBoxOffset: ${JSON.stringify(res)}, offset:`)
  return res
}

export function mergeMatrix(groupBoxTranslate: matrix4.Matrix4Transit | undefined, combineMetrics: matrix4.Matrix4Transit | undefined, matrix: number[] | undefined): matrix4.Matrix4Transit {
  let metrics = combineMetrics

  if (!metrics) {
    if (matrix?.length === 6) {
      metrics = getTransform(matrix) as matrix4.Matrix4Transit
    }
  }

  metrics = metrics || matrix4.identity().translate({ x: 0, y: 0 })
  if (groupBoxTranslate) {
    return groupBoxTranslate.copy().combine(metrics)
  }
  return metrics
}