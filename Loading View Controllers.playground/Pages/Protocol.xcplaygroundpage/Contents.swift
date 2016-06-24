import UIKit

// To run this playground start a SimpleHTTPServer on the commandline like this:
//
// python -m SimpleHTTPServer 8000
//
// It will serve up the current directory, so make sure to be in the directory containing episode.json

let url = NSURL(string: "http://localhost:8000/episode.json")!
let episodeResource = Resource<Episode>(url: url, parseJSON: { anyObject in
    (anyObject as? JSONDictionary).flatMap(Episode.init)
})


let sharedWebservice = Webservice()


protocol Loading {
    associatedtype ResourceType
    var spinner: UIActivityIndicatorView { get }
    func configure(value: ResourceType)
}

extension Loading where Self: UIViewController {
    func load(resource: Resource<ResourceType>) {
        spinner.startAnimating()
        sharedWebservice.load(resource) { [weak self] result in
            self?.spinner.stopAnimating()
            guard let value = result.value else { return } // TODO loading error
            self?.configure(value)
        }
    }
}


final class EpisodeDetailViewController: UIViewController, Loading {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let titleLabel = UILabel()
    
    convenience init(episode: Episode) {
        self.init()
        configure(episode)
    }
    
    convenience init(resource: Resource<Episode>) {
        self.init()
        load(resource)
    }
    
    func configure(value: Episode) {
        titleLabel.text = value.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()

        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.center(inView: view)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.constrainEdges(toMarginOf: view)
    }
}


let episodesVC = EpisodeDetailViewController(resource: episodeResource)
episodesVC.view.frame = CGRect(x: 0, y: 0, width: 250, height: 300)


import XCPlayground
XCPlaygroundPage.currentPage.liveView = episodesVC
