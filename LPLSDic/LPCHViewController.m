//
//  LPCHViewController.m
//  乐搜
//
//  Created by mickey on 16/7/20.
//  Copyright © 2016年 李盼. All rights reserved.
//

#import "LPCHViewController.h"

@interface LPCHViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LPCHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
  self.tabBarController.tabBar.translucent =NO;
    // Do any additional setup after loading the view.
//  self.webView.scalesPageToFit= YES;
//  self.webView.layer.borderColor =[[UIColor lightGrayColor]CGColor];
//  self.webView.layer.borderWidth = 0.5;
//  self.webView.layer.masksToBounds = YES;
//  self.webView.opaque = NO;
//  self.webView.scalesPageToFit=YES;
  NSURL * url =[NSURL URLWithString:[NSString stringWithFormat:@"https://pokemongo.gamepress.gg/pokemon/2"]];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
//  [self.webView loadHTMLString:@"<select class=""form-control"" data-bind=""options: evolutionPokemons, optionsCaption: 'Select a Pokemon', optionsText: function(p){ return p.Name + ' - ' + p.Number }, value: selectedPokemon""><option value="">Select a Pokemon</option><option value="">Abra - 063</option><option value="">Bellsprout - 069</option><option value="">Bulbasaur - 001</option><option value="">Caterpie - 010</option><option value="">Charmander - 004</option><option value="">Charmeleon - 005</option><option value="">Clefairy - 035</option><option value="">Cubone - 104</option><option value="">Diglett - 050</option><option value="">Doduo - 084</option><option value="">Dragonair - 148</option><option value="">Dratini - 147</option><option value="">Drowzee - 096</option><option value="">Eevee - 133</option><option value="">Ekans - 023</option><option value="">Exeggcute - 102</option><option value="">Gastly - 092</option><option value="">Geodude - 074</option><option value="">Gloom - 044</option><option value="">Goldeen - 118</option><option value="">Graveler - 075</option><option value="">Grimer - 088</option><option value="">Growlithe - 058</option><option value="">Haunter - 093</option><option value="">Horsea - 116</option><option value="">Ivysaur - 002</option><option value="">Jigglypuff - 039</option><option value="">Kabuto - 140</option><option value="">Kadabra - 064</option><option value="">Kakuna - 014</option><option value="">Koffing - 109</option><option value="">Krabby - 098</option><option value="">Machoke - 067</option><option value="">Machop - 066</option><option value="">Magikarp - 129</option><option value="">Magnemite - 081</option><option value="">Mankey - 056</option><option value="">Meowth - 052</option><option value="">Metapod - 011</option><option value="">Nidoran(Female) - 029</option><option value="">Nidoran(Male) - 032</option><option value="">Nidorina - 030</option><option value="">Nidorino - 033</option><option value="">Oddish - 043</option><option value="">Omanyte - 138</option><option value="">Paras - 046</option><option value="">Pidgeotto - 017</option><option value="">Pidgey - 016</option><option value="">Pikachu - 025</option><option value="">Poliwag - 060</option><option value="">Poliwhirl - 061</option><option value="">Ponyta - 077</option><option value="">Psyduck - 054</option><option value="">Rattata - 019</option><option value="">Rhyhorn - 111</option><option value="">Sandshrew - 027</option><option value="">Seel - 086</option><option value="">Shellder - 090</option><option value="">Slowpoke - 079</option><option value="">Spearow - 021</option><option value="">Squirtle - 007</option><option value="">Staryu - 120</option><option value="">Tentacool - 072</option><option value="">Venonat - 048</option><option value="">Voltorb - 100</option><option value="">Vulpix - 037</option><option value="">Wartortle - 008</option><option value="">Weedle - 013</option><option value="">Weepinbell - 070</option><option value="">Zubat - 041</option></select>" baseURL:nil];
  [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
