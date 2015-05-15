defmodule Slim.Builder.Element.Doctype do
  def match?([element]), do: Regex.match?(~r(^doctype ), element)
  def match?(_), do: false
  def build([element], padding) do
    case Regex.replace(~r/^(doctype\s+)/, element, "") do
      doctype when doctype == "html" or doctype == 5 -> ~s(<!DOCTYPE html>)
      doctype when doctype == "1.1" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">)
      doctype when doctype == "strict" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">)
      doctype when doctype == "frameset" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">)
      doctype when doctype == "mobile" -> ~s(<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">)
      doctype when doctype == "basic" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">)
      doctype when doctype == "transitional" -> ~s(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">)
    end <> Slim.Config.new_line
  end
end
