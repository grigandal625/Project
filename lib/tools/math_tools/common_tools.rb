module Tools
  module MathTools
    class CommonTools
      def average(arr)
        s = 0
        arr.each { |e| s = s.round + e }
        s / arr.size.to_f
      end

      def sum_square(arr)
        s = 0
        arr.map { |x| x*x }.each { |e| s = s.round + e }
        s
      end

      def sum(arr)
        s = 0
        arr.each { |e| s = s.round + e }
        s
      end

      def pearson_coefficient(arr_x, arr_y)
        x_avg = average(arr_x)
        y_avg = average(arr_y)
        x_intermediate = arr_x.map { |x| x - x_avg}
        y_intermediate = arr_y.map { |y| y - y_avg}

        r = sum(x_intermediate) * sum(y_intermediate) / Math.sqrt((sum_square(x_intermediate) * sum_square(y_intermediate)).to_f)
        return r
      end
    end
  end
end