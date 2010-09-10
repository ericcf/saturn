module Formatters

  module Person

    def full_name(*options)
      options.include?(:family_first) ? [
        [family_name, suffixes].compact.join(" "),
        [given_name, other_given_names].compact.join(" ")
      ].compact.join(", ") : [
        given_name,
        other_given_names,
        family_name,
        suffixes
      ].compact.join(" ")
    end
  end
end
