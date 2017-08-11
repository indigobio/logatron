require 'abstractivator/enumerator_ext'

module Logatron
  class ErrorFormatter
    def format_short_message(e)
      "#{e.class}: #{e.message}"
    end

    def format_full_message(e, additional_info = nil)
      format_short_message(e) + format_additional_info(e, additional_info)
    end

    def format_backtrace(error_or_bt)
      bt = error_or_bt.is_a?(Exception) ? error_or_bt.backtrace : error_or_bt
      bt.map { |f| "      #{f.starts_with?('...') ? f : "at #{f}"}\n" }.join
    end

    def format_additional_info(e, additional_info = nil)
      info = additional_info || (e.respond_to?(:meta) && e.meta)
      info ? "; MORE_INFO( #{info.to_s} )" : ''
    end

    # Returns a human-readable exception report.
    # Includes nested exception information.
    # Suppresses duplicate frames in nested exception backtraces.
    def format_error_report(e, additional_info = nil)
      error_chain = Enumerator.unfold(e) { |e| [e.cause, e.cause] }.to_a
      initial_report = format_single_error(e, clean_backtrace(nil, e), additional_info)
      # starting with the outermost error, reduce the error chain into the formatted report
      error_chain.reduce([e, initial_report]) do |(prev_e, report), e|
        new_report = format_single_error(e, clean_backtrace(prev_e, e)) + "  which caused:\n    " + report
        [e, new_report]
      end[1]
    rescue
      # if something went wrong, fall back to something simpler
      format_short_message(e) + "\n" + e.backtrace.join("\n")
    end

    private

    def format_single_error(e, cleaned_backtrace, additional_info = nil)
      format_full_message(e, additional_info) + "\n" + format_backtrace(cleaned_backtrace)
    end

    def clean_backtrace(prev, e)
      base_size = prev ? num_common_base_frames(prev, e) : 0
      cleaned_backtrace =
          if base_size > 1
            num_to_suppress = base_size - 1
            e.backtrace.take(e.backtrace.size - num_to_suppress) +
                ["... #{num_to_suppress} frames suppressed ..."]
          else
            backtrace_cleaner.clean(e.backtrace)
          end
    end

    def backtrace_cleaner
      Logatron.configuration.backtrace_cleaner
    end

    def num_common_base_frames(e1, e2)
      e1.backtrace.reverse.zip(e2.backtrace.reverse)
          .take_while { |(a, b)| a == b }
          .size
    end
  end
end
