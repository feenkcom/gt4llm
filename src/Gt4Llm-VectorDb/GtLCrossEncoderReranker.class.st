Class {
	#name : #GtLCrossEncoderReranker,
	#superclass : #Object,
	#category : #'Gt4Llm-VectorDb-RAG'
}

{ #category : #api }
GtLCrossEncoderReranker >> reRank: matchingEmbeddings in: aLepiterRagContext [
	| crossEncoder rankings updatedEmbeddings offset |

	crossEncoder := GtLSentenceTransformerCrossEncoder default.
	rankings := crossEncoder
		reRankQuery: aLepiterRagContext queryString
		documents: (matchingEmbeddings collect: #document).
	"The cross-encoder has highest value as best match,
	while we are using distance, i.e. closer is better.
	Update the cross-encoder values to be a 'distance'."
	updatedEmbeddings := GtLNearestEmbeddingGroup new items: 
		(matchingEmbeddings collect: #copy).
	offset := rankings first second + 1.
	rankings do: [ :anArray |
		(updatedEmbeddings at: anArray first + 1) distance: (offset - anArray second) ].
	^ updatedEmbeddings
]
