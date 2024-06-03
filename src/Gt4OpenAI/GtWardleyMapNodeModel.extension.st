Extension { #name : #GtWardleyMapNodeModel }

{ #category : #'*Gt4OpenAI' }
GtWardleyMapNodeModel >> asDifferenceNode [
	^ GtWardleyMapNodeDifferenceModel from: self
]
