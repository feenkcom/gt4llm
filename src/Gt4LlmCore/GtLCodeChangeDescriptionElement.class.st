Class {
	#name : #GtLCodeChangeDescriptionElement,
	#superclass : #BrHorizontalPane,
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLCodeChangeDescriptionElement >> buildNewLabel [
	^ BrLabel new aptitude: BrGlamorousLabelAptitude new
]

{ #category : #accessing }
GtLCodeChangeDescriptionElement >> displayBehavior: aString [ 

	^ GtEpiceaBrickFactory default emphasizedStringFor: aString 
]

{ #category : #accessing }
GtLCodeChangeDescriptionElement >> displayOperation: aString [ 
	^ self 
			displayString: aString 
			color: GtEpiceaBrickFactory default softerTextColor
]

{ #category : #accessing }
GtLCodeChangeDescriptionElement >> displayString: aString [

	^ GtEpiceaBrickFactory default stringFor: aString 
]

{ #category : #accessing }
GtLCodeChangeDescriptionElement >> displayString: aString color: aColor [

	^ GtEpiceaBrickFactory default stringFor: aString color: aColor 
]
