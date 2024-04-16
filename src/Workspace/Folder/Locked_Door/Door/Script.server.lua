function onTouched(hit)
	if hit.Parent:findFirstChild("Humanoid") ~= nil then
		if game.Players:findFirstChild(hit.Parent.Name) ~= nil then
			if hit.Parent:findFirstChild(script.Parent.Parent.Key.Value) ~= nil then
				if script.Parent.Parent.KeyRemove.Value == true then
					hit.Parent:findFirstChild(script.Parent.Parent.Key.Value):remove()
				end
				script.Parent.Transparency = 0.8
				script.Parent.CanCollide = false
				wait(3)
				script.Parent.Transparency = 0
				script.Parent.CanCollide = true
			end
		end
	end
end
script.Parent.Touched:connect(onTouched)
