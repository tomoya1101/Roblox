function onTouch(part)
h = part.Parent:FindFirstChild("Humanoid")
if (h~=nil) then
h.Parent:MoveTo(script.Parent.Parent.Tele2.Position)
end
end
script.Parent.Touched:connect(onTouch)