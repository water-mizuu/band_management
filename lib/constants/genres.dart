typedef Genre = ({
  String name,
  String path,
});

const genres = <String, Genre>{
  'jazz': (
    name: 'Jazz',
    path: 'assets/jazz.jpg',
  ),
  'pop': (
    name: 'Pop',
    path: 'assets/pop.jpg',
  ),
  'soul': (
    name: 'Soul',
    path: 'assets/soul.jpg',
  ),
  'rock': (
    name: 'Rock',
    path: 'assets/rock.jpg',
  ),
  'rap': (
    name: 'Rap',
    path: 'assets/rap.jpg',
  ),
};
