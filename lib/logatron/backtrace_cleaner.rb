module Logatron
  class BacktraceCleaner
    # Suppress irrelevant "external" frames. In practice, these are often the frames
    # leading up to the "entry point" we care about, whether that's a rails controller
    # or a rabbit_stew handler.
    #
    # Algorithm: partition frames into contiguous external/internal chunks.
    # Starting at the bottom, suppress chunks until we find the entry point chunk.

    def clean(backtrace)
      all_chunks = backtrace.chunk { |x| external_frame?(x) }.to_a.reverse
      good_chunks = all_chunks.drop_while { |(is_ext, frames)| !entry_point_chunk?(is_ext, frames) }
      bad_chunks = all_chunks.take(all_chunks.size - good_chunks.size)
      good_bt = good_chunks.reverse.map(&:last).flatten
      bad_bt = bad_chunks.reverse.map(&:last).flatten
      good_bt + suppress(bad_bt)
    rescue
      # if something went wrong, give up on cleaning the backtrace
      backtrace
    end

    private

    # heuristic for determining externality of a frame.
    # Note: bundle/gems does not include git-sourced gems (those go in
    # bundle/bundler/gems), so git-sourced gems are considered internal.
    def external_frame?(f)
      !!(f =~ %r{bundle/gems})
    end

    # heuristic for finding the entry point
    def entry_point_chunk?(is_ext, frames)
      !is_ext && frames.size >= 3
    end

    def suppress(backtrace)
      if backtrace.size <= 3
        backtrace
      else
        [ backtrace.first,
          "... #{backtrace.size - 2} frames suppressed ...",
          backtrace.last ]
      end
    end
  end
end
