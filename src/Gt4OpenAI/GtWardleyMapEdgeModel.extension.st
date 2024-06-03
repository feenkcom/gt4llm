Extension { #name : #GtWardleyMapEdgeModel }

{ #category : #'*Gt4OpenAI' }
GtWardleyMapEdgeModel >> asDifferenceEdge [
	^ GtWardleyMapEdgeDifferenceModel from: self
]
