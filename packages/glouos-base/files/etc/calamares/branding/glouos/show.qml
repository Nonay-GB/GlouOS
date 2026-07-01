import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 6000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "slide1.svg"
        }
    }

    Slide {
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "slide2.svg"
        }
    }

    Slide {
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "slide3.svg"
        }
    }
}
