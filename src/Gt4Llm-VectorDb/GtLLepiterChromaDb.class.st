Class {
	#name : #GtLLepiterChromaDb,
	#superclass : #GtLLepiterVectorDb,
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #'instance creation' }
GtLLepiterChromaDb class >> collectionName: aString [

	^ self new
		vectorDb: (LeChromaDb new
			collectionName: aString)
]
