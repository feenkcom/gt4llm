Class {
	#name : #GtLCodeChangeDescriptionElement,
	#superclass : #BrHorizontalPane,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLCodeChangeDescriptionElement >> buildNewLabel [
	^ BrLabel new aptitude: BrGlamorousLabelAptitude new
]
